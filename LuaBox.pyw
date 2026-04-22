import sys
import re
import subprocess
import tempfile
import os
import fnmatch
import random
import socket
import threading
import struct

from PyQt6.QtWidgets import (
    QApplication, QMainWindow, QTextEdit, QVBoxLayout,
    QHBoxLayout, QWidget, QPushButton, QLabel, QSplitter,
    QPlainTextEdit, QStatusBar, QFileDialog, QTreeWidget,
    QTreeWidgetItem, QTabWidget, QMessageBox, QDialog,
    QFormLayout, QComboBox, QSpinBox, QCheckBox, QMenu,
    QLineEdit, QRadioButton, QButtonGroup, QScrollBar
)
from PyQt6.QtGui import (
    QFont, QColor, QTextCharFormat, QSyntaxHighlighter,
    QPainter, QTextFormat, QAction, QIcon, QTextDocument
)
from PyQt6.QtCore import Qt, QRect, QSize, QDir, QUrl, QEventLoop, QProcess, QProcessEnvironment
from PyQt6.QtWebEngineWidgets import QWebEngineView
from PyQt6.QtWebEngineCore import QWebEngineSettings

from PyQt6.QtCore import QFileSystemWatcher, QTimer


# ── Centralised theme definitions ──────────────────────────────────────────────
THEMES = {
    "Light": {
        # General UI
        "app_bg":          "#F0F0F0",
        "toolbar_bg":      "#F0F0F0",
        "toolbar_border":  "#CCCCCC",
        "btn_bg":          "#E1E1E1",
        "btn_fg":          "#000000",
        "btn_border_tl":   "#FFFFFF",
        "btn_border_br":   "#7A7A7A",
        "btn_border_out":  "#ADADAD",
        "btn_hover_bg":    "#E5F1FB",
        "btn_hover_border":"#0078D7",
        "btn_press_bg":    "#CCE8FF",
        "tree_bg":         "#FFFFFF",
        "tree_alt":        "#F5F5F5",
        "tree_border":     "#ADADAD",
        "tree_sel_bg":     "#0078D7",
        "tree_sel_fg":     "#FFFFFF",
        "tree_hover":      "#E5F1FB",
        "tab_bg":          "#E1E1E1",
        "tab_sel_bg":      "#FFFFFF",
        "tab_hover_bg":    "#E5F1FB",
        "tab_border":      "#ADADAD",
        "tab_pane_bg":     "#FFFFFF",
        "tab_pane_border": "#CCCCCC",
        "splitter_bg":     "#E0E0E0",
        "explorer_hdr_bg": "#F0F0F0",
        "explorer_hdr_bd": "#CCCCCC",
        "label_fg":        "#000000",
        "status_fg":       "#444444",
        # Editor
        "editor_bg":       "#FFFFFF",
        "editor_fg":       "#000000",
        "editor_sel":      "#ADD6FF",
        "lineno_bg":       "#E8E8E8",
        "lineno_fg":       "#666666",
        "curline_bg":      "#E8F4FF",
        # Syntax
        "syn_keyword":     "#0000CC",
        "syn_builtin":     "#7C00D4",
        "syn_roblox":      "#007070",
        "syn_number":      "#098658",
        "syn_string":      "#A31515",
        "syn_comment":     "#228B22",
        # Accent buttons
        "btn_settings":    "#E8D6F0",
        "btn_format":      "#E6F3FF",
        "btn_bridge":      "#E6FFE8",
    },
    "Dark": {
        # General UI
        "app_bg":          "#1E1E1E",
        "toolbar_bg":      "#2D2D2D",
        "toolbar_border":  "#3F3F3F",
        "btn_bg":          "#3C3C3C",
        "btn_fg":          "#D4D4D4",
        "btn_border_tl":   "#555555",
        "btn_border_br":   "#1A1A1A",
        "btn_border_out":  "#555555",
        "btn_hover_bg":    "#094771",
        "btn_hover_border":"#007ACC",
        "btn_press_bg":    "#0E639C",
        "tree_bg":         "#252526",
        "tree_alt":        "#2A2A2B",
        "tree_border":     "#3F3F3F",
        "tree_sel_bg":     "#094771",
        "tree_sel_fg":     "#FFFFFF",
        "tree_hover":      "#2A2D2E",
        "tab_bg":          "#2D2D2D",
        "tab_sel_bg":      "#1E1E1E",
        "tab_hover_bg":    "#2A2D2E",
        "tab_border":      "#3F3F3F",
        "tab_pane_bg":     "#1E1E1E",
        "tab_pane_border": "#3F3F3F",
        "splitter_bg":     "#3F3F3F",
        "explorer_hdr_bg": "#2D2D2D",
        "explorer_hdr_bd": "#3F3F3F",
        "label_fg":        "#CCCCCC",
        "status_fg":       "#999999",
        # Editor
        "editor_bg":       "#1E1E1E",
        "editor_fg":       "#D4D4D4",
        "editor_sel":      "#264F78",
        "lineno_bg":       "#252526",
        "lineno_fg":       "#858585",
        "curline_bg":      "#2A2D2E",
        # Syntax (VS Code Dark+ inspired)
        "syn_keyword":     "#569CD6",
        "syn_builtin":     "#C586C0",
        "syn_roblox":      "#4EC9B0",
        "syn_number":      "#B5CEA8",
        "syn_string":      "#CE9178",
        "syn_comment":     "#6A9955",
        # Accent buttons
        "btn_settings":    "#3D2B4F",
        "btn_format":      "#1B3A5C",
        "btn_bridge":      "#1A3D25",
    },
}

_current_theme = "Light"

def get_theme():
    return THEMES[_current_theme]


# --- Line Number Area Widget ---
class LineNumberArea(QWidget):
    def __init__(self, editor):
        super().__init__(editor)
        self.editor = editor

    def sizeHint(self):
        return QSize(self.editor.line_number_area_width(), 0)

    def paintEvent(self, event):
        self.editor.line_number_area_paint_event(event)


# --- Code Editor with Line Numbers ---
class CodeEditor(QPlainTextEdit):
    def __init__(self):
        super().__init__()
        self.line_number_area = LineNumberArea(self)
        
        self.blockCountChanged.connect(self.update_line_number_area_width)
        self.updateRequest.connect(self.update_line_number_area)
        self.cursorPositionChanged.connect(self.highlight_current_line)
        
        self.update_line_number_area_width(0)
        self.highlight_current_line()
        
        # Zoom level tracking
        self.zoom_level = 0
        self.base_font_size = 11

    def wheelEvent(self, event):
        """Handle zoom with Ctrl + scroll wheel."""
        if event.modifiers() == Qt.KeyboardModifier.ControlModifier:
            delta = event.angleDelta().y()
            if delta > 0:
                self.zoom_in()
            elif delta < 0:
                self.zoom_out()
            event.accept()
        else:
            super().wheelEvent(event)
    
    def zoom_in(self):
        """Increase font size."""
        if self.zoom_level < 10:
            self.zoom_level += 1
            self.update_font_size()
    
    def zoom_out(self):
        """Decrease font size."""
        if self.zoom_level > -5:
            self.zoom_level -= 1
            self.update_font_size()
    
    def reset_zoom(self):
        """Reset zoom to default."""
        self.zoom_level = 0
        self.update_font_size()
    
    def update_font_size(self):
        """Update the font size based on zoom level."""
        new_size = self.base_font_size + self.zoom_level
        font = self.font()
        font.setPointSize(new_size)
        self.setFont(font)
        self.update_line_number_area_width(0)

    def line_number_area_width(self):
        digits = len(str(max(1, self.blockCount())))
        space = 10 + self.fontMetrics().horizontalAdvance('9') * digits
        return space

    def update_line_number_area_width(self, _):
        self.setViewportMargins(self.line_number_area_width(), 0, 0, 0)

    def update_line_number_area(self, rect, dy):
        if dy:
            self.line_number_area.scroll(0, dy)
        else:
            self.line_number_area.update(0, rect.y(), self.line_number_area.width(), rect.height())

        if rect.contains(self.viewport().rect()):
            self.update_line_number_area_width(0)

    def resizeEvent(self, event):
        super().resizeEvent(event)
        cr = self.contentsRect()
        self.line_number_area.setGeometry(QRect(cr.left(), cr.top(), self.line_number_area_width(), cr.height()))

    def line_number_area_paint_event(self, event):
        t = get_theme()
        painter = QPainter(self.line_number_area)
        painter.fillRect(event.rect(), QColor(t["lineno_bg"]))

        block = self.firstVisibleBlock()
        block_number = block.blockNumber()
        top = self.blockBoundingGeometry(block).translated(self.contentOffset()).top()
        bottom = top + self.blockBoundingRect(block).height()

        while block.isValid() and top <= event.rect().bottom():
            if block.isVisible() and bottom >= event.rect().top():
                number = str(block_number + 1)
                painter.setPen(QColor(t["lineno_fg"]))
                painter.drawText(0, int(top), self.line_number_area.width() - 5,
                               self.fontMetrics().height(), Qt.AlignmentFlag.AlignRight, number)

            block = block.next()
            top = bottom
            bottom = top + self.blockBoundingRect(block).height()
            block_number += 1

    def highlight_current_line(self):
        extra_selections = []

        if not self.isReadOnly():
            selection = QTextEdit.ExtraSelection()
            line_color = QColor(get_theme()["curline_bg"])
            selection.format.setBackground(line_color)
            selection.format.setProperty(QTextFormat.Property.FullWidthSelection, True)
            selection.cursor = self.textCursor()
            selection.cursor.clearSelection()
            extra_selections.append(selection)

        self.setExtraSelections(extra_selections)


# --- Syntax Highlighting ---
class LuaSyntaxHighlighter(QSyntaxHighlighter):
    def __init__(self, parent):
        super().__init__(parent)
        self.highlighting_rules = []
        self._build_rules()

    def _build_rules(self):
        t = get_theme()
        self.highlighting_rules = []

        # --- Keywords ---
        keyword_format = QTextCharFormat()
        keyword_format.setForeground(QColor(t["syn_keyword"]))
        keyword_format.setFontWeight(700)
        keywords = [
            "and", "break", "do", "else", "elseif", "end", "false",
            "for", "function", "if", "in", "local", "nil", "not",
            "or", "repeat", "return", "then", "true", "until", "while",
        ]
        for kw in keywords:
            self.highlighting_rules.append(
                (re.compile(r'\b' + kw + r'\b'), keyword_format)
            )

        # --- Built-ins ---
        builtin_format = QTextCharFormat()
        builtin_format.setForeground(QColor(t["syn_builtin"]))
        builtins = [
            "print", "tostring", "tonumber", "type", "pairs", "ipairs",
            "unpack", "select", "next", "error", "assert", "pcall",
            "xpcall", "rawget", "rawset", "rawequal", "setmetatable",
            "getmetatable", "require", "loadstring", "load", "dofile",
            "collectgarbage",
            "table", "string", "math", "os", "io", "coroutine",
            "game", "workspace", "script", "task", "warn", "tick",
            "wait", "spawn", "delay",
        ]
        for b in builtins:
            self.highlighting_rules.append(
                (re.compile(r'\b' + b + r'\b'), builtin_format)
            )

        # --- Roblox services/objects ---
        roblox_format = QTextCharFormat()
        roblox_format.setForeground(QColor(t["syn_roblox"]))
        roblox_names = [
            "Instance", "Vector3", "Vector2", "CFrame", "Color3",
            "UDim2", "UDim", "TweenInfo", "Enum", "Drawing",
            "Players", "RunService", "UserInputService", "TweenService",
            "ReplicatedStorage", "ServerStorage", "Workspace",
            "HttpService", "CoreGui", "Lighting",
        ]
        for r in roblox_names:
            self.highlighting_rules.append(
                (re.compile(r'\b' + r + r'\b'), roblox_format)
            )

        # --- Numbers ---
        number_format = QTextCharFormat()
        number_format.setForeground(QColor(t["syn_number"]))
        self.highlighting_rules.append(
            (re.compile(r'\b\d+(\.\d+)?\b'), number_format)
        )

        # --- Strings ---
        self.string_format = QTextCharFormat()
        self.string_format.setForeground(QColor(t["syn_string"]))

        # --- Comments ---
        self.comment_format = QTextCharFormat()
        self.comment_format.setForeground(QColor(t["syn_comment"]))
        self.comment_format.setFontItalic(True)

        self.single_comment_re = re.compile(r'--(?!\[\[).*')
        self.ml_start_re = re.compile(r'--\[\[')
        self.ml_end_str = ']]'

    def rehighlight_with_theme(self):
        self._build_rules()
        self.rehighlight()

    # ------------------------------------------------------------------
    def highlightBlock(self, text):
        # ---- 1. Apply simple regex rules (keywords, builtins, numbers) ----
        for pattern, fmt in self.highlighting_rules:
            for m in pattern.finditer(text):
                self.setFormat(m.start(), m.end() - m.start(), fmt)

        # ---- 2. Handle strings manually so we don't colour inside comments ----
        #         and so comments inside strings are ignored.
        self._highlight_strings(text)

        # ---- 3. Multi-line comment handling ----
        self.setCurrentBlockState(0)

        if self.previousBlockState() == 1:
            # We're continuing a multi-line comment from the previous block
            end = text.find(self.ml_end_str)
            if end == -1:
                # Entire line is inside the comment
                self.setCurrentBlockState(1)
                self.setFormat(0, len(text), self.comment_format)
                return
            else:
                # Comment ends on this line
                self.setFormat(0, end + 2, self.comment_format)
                # Continue scanning for a new --[[ after the ]]
                scan_from = end + 2
        else:
            scan_from = 0

        # Search for --[[ in the current block (outside strings)
        while True:
            m = self.ml_start_re.search(text, scan_from)
            if not m:
                break
            start = m.start()
            end_idx = text.find(self.ml_end_str, start + 4)
            if end_idx == -1:
                # Opens but doesn't close — mark rest of block
                self.setCurrentBlockState(1)
                self.setFormat(start, len(text) - start, self.comment_format)
                return
            else:
                self.setFormat(start, end_idx + 2 - start, self.comment_format)
                scan_from = end_idx + 2

        # ---- 4. Single-line comments (applied last so they override everything) ----
        for m in self.single_comment_re.finditer(text):
            self.setFormat(m.start(), len(text) - m.start(), self.comment_format)

    # ------------------------------------------------------------------
    def _highlight_strings(self, text):
        """Colour string literals, respecting escape sequences."""
        i = 0
        n = len(text)
        while i < n:
            ch = text[i]
            if ch in ('"', "'"):
                quote = ch
                j = i + 1
                while j < n:
                    if text[j] == '\\':
                        j += 2          # skip escaped char
                        continue
                    if text[j] == quote:
                        j += 1
                        break
                    j += 1
                self.setFormat(i, j - i, self.string_format)
                i = j
            else:
                i += 1



# --- Smart Comment Remover ---
class LuaCommentRemover:
    """Intelligently removes comments while preserving code structure."""
    
    @staticmethod
    def remove_comments(code):
        """
        Remove Lua comments intelligently:
        - Preserves strings (doesn't touch -- inside strings)
        - Keeps code on lines with trailing comments
        - Only removes lines that are purely comments
        - Handles multi-line comments properly
        """
        lines = code.split('\n')
        result_lines = []
        in_multiline_comment = False
        
        for line in lines:
            # Check if we're in a multi-line comment
            if in_multiline_comment:
                if ']]' in line:
                    # End of multi-line comment
                    after_comment = line.split(']]', 1)[1]
                    in_multiline_comment = False
                    if after_comment.strip():
                        result_lines.append(after_comment)
                continue
            
            # Check for start of multi-line comment
            if '--[[' in line:
                before_comment = line.split('--[[', 1)[0]
                remaining = line.split('--[[', 1)[1]
                
                # Check if it closes on the same line
                if ']]' in remaining:
                    after_comment = remaining.split(']]', 1)[1]
                    cleaned = before_comment + after_comment
                    if cleaned.strip():
                        result_lines.append(cleaned)
                else:
                    # Multi-line comment starts
                    in_multiline_comment = True
                    if before_comment.strip():
                        result_lines.append(before_comment)
                continue
            
            # Handle single-line comments
            cleaned_line = LuaCommentRemover._remove_single_line_comment(line)
            
            # Only add non-empty lines
            if cleaned_line.strip():
                result_lines.append(cleaned_line)
        
        return '\n'.join(result_lines)
    
    @staticmethod
    def _remove_single_line_comment(line):
        """Remove single-line comment while respecting strings."""
        # We need to find -- that's not inside a string
        in_string = False
        string_char = None
        escaped = False
        
        for i, char in enumerate(line):
            if escaped:
                escaped = False
                continue
            
            if char == '\\':
                escaped = True
                continue
            
            # Track string state
            if char in ['"', "'"] and not in_string:
                in_string = True
                string_char = char
            elif char == string_char and in_string:
                in_string = False
                string_char = None
            
            # Look for -- outside of strings
            elif not in_string and char == '-' and i + 1 < len(line) and line[i + 1] == '-':
                # Found a comment marker outside a string
                return line[:i].rstrip()
        
        return line


# --- Format Options Dialog ---
class FormatOptionsDialog(QDialog):
    """
    Customisable Lua formatter options dialog.
    All settings are exposed so the user can tune exactly how the output looks.
    Includes Shape Mode — reflow code tokens to fill a silhouette (ASCII-art style).
    """

    DEFAULTS = {
        "indent_style":        "spaces",
        "indent_size":         4,
        "max_blank_lines":     2,
        "space_operators":     True,
        "space_after_comma":   True,
        "trailing_whitespace": True,
        "normalize_min_indent":True,
        "semicolon_removal":   False,
        "newline_before_end":  False,
        "compact_empty_blocks":True,
        "align_assignments":   False,
        # Shape mode
        "shape_mode":          False,
        "shape_name":          "Among Us",
        "shape_custom":        "",
        "shape_width":         120,
    }

    PRESETS = {
        "Default":  {},
        "Compact":  {"max_blank_lines": 0, "newline_before_end": False, "align_assignments": False},
        "Expanded": {"max_blank_lines": 2, "newline_before_end": True},
        "Tabs":     {"indent_style": "tabs"},
        "2-Space":  {"indent_size": 2, "indent_style": "spaces"},
        "Strict":   {"semicolon_removal": True, "trailing_whitespace": True,
                     "normalize_min_indent": True, "space_operators": True,
                     "space_after_comma": True},
    }

    # ── Built-in shape silhouettes ────────────────────────────────────────────
    # Each shape is a list of strings. '#' = filled cell, ' ' = empty.
    # They're designed at ~60 chars wide; the engine scales to shape_width.
    SHAPES = {
        "Among Us": [
            "          ##########          ",
            "       ################       ",
            "      ##################      ",
            "     ####################     ",
            "    ######################    ",
            "    ######################    ",
            "    ######        ########    ",
            "    ######        ########    ",
            "    ######        ########    ",
            "    ######################    ",
            "    ######################    ",
            "    ######################    ",
            "    ######################    ",
            "    ######################    ",
            "    ######################    ",
            "    ######################    ",
            "    ######################    ",
            "    ######################    ",
            "     ####################     ",
            "     ####################     ",
            "     ###########  #######     ",
            "     ##########    ######     ",
            "    #########      ######     ",
            "    ########       ######     ",
            "    ########       ######     ",
            "    ########       ######     ",
            "    #########     #######     ",
            "     #####################    ",
        ],
        "Heart": [
            "    ######    ######    ",
            "  ##########  #######   ",
            " ############ ########  ",
            " #####################  ",
            " #####################  ",
            "  ###################   ",
            "   #################    ",
            "    ###############     ",
            "     #############      ",
            "      ###########       ",
            "       #########        ",
            "        #######         ",
            "         #####          ",
            "          ###           ",
            "           #            ",
        ],
        "Skull": [
            "     ###########     ",
            "   ###############   ",
            "  #################  ",
            " ################### ",
            " ################### ",
            " ## ### ##### ### ## ",
            " ##     #####     ## ",
            " ## ### ##### ### ## ",
            " ################### ",
            " ################### ",
            "  #################  ",
            "  ### ######### ###  ",
            "  ### ######### ###  ",
            "   #################   ",
            "    ###########    ",
        ],
        "Roblox R": [
            " ################  ",
            " ################  ",
            " ####   ########   ",
            " ####   ########   ",
            " ####   ########   ",
            " ################  ",
            " ################  ",
            " ########          ",
            " #######           ",
            " ######            ",
            " #####             ",
            " ####              ",
            " ###               ",
        ],
        "Arrow": [
            "          #         ",
            "         ###        ",
            "        #####       ",
            "       #######      ",
            "      #########     ",
            "         ###        ",
            "         ###        ",
            "         ###        ",
            "         ###        ",
            "         ###        ",
            "         ###        ",
        ],
        "Diamond": [
            "          #          ",
            "         ###         ",
            "        #####        ",
            "       #######       ",
            "      #########      ",
            "     ###########     ",
            "    #############    ",
            "     ###########     ",
            "      #########      ",
            "       #######       ",
            "        #####        ",
            "         ###         ",
            "          #          ",
        ],
        "Custom": [],   # filled from the text box
    }

    def __init__(self, parent=None, saved_options: dict = None):
        super().__init__(parent)
        self.setWindowTitle("Format Options")
        self.setModal(True)
        self.setMinimumWidth(520)

        self.opts = dict(self.DEFAULTS)
        if saved_options:
            self.opts.update(saved_options)

        root = QVBoxLayout(self)
        root.setSpacing(8)

        # ── Preset row ────────────────────────────────────────────────────
        preset_row = QHBoxLayout()
        preset_row.addWidget(QLabel("Preset:"))
        self.preset_combo = QComboBox()
        self.preset_combo.addItems(list(self.PRESETS.keys()))
        self.preset_combo.currentTextChanged.connect(self._apply_preset)
        preset_row.addWidget(self.preset_combo)
        preset_row.addStretch()
        root.addLayout(preset_row)

        sep0 = QWidget(); sep0.setFixedHeight(1)
        sep0.setStyleSheet("background-color:#CCCCCC;")
        root.addWidget(sep0)

        # ── Standard formatter form ───────────────────────────────────────
        form = QFormLayout()
        form.setHorizontalSpacing(16)
        form.setVerticalSpacing(6)

        self.indent_style = QComboBox()
        self.indent_style.addItems(["spaces", "tabs"])
        self.indent_style.setCurrentText(self.opts["indent_style"])
        self.indent_style.currentTextChanged.connect(self._sync_indent_size_state)
        form.addRow("Indent style:", self.indent_style)

        self.indent_size = QSpinBox()
        self.indent_size.setRange(1, 8)
        self.indent_size.setValue(self.opts["indent_size"])
        self.indent_size.setSuffix(" spaces")
        form.addRow("Indent size:", self.indent_size)
        self._sync_indent_size_state(self.opts["indent_style"])

        self.max_blank_lines = QSpinBox()
        self.max_blank_lines.setRange(0, 5)
        self.max_blank_lines.setValue(self.opts["max_blank_lines"])
        self.max_blank_lines.setToolTip("Collapse runs of blank lines to at most this many")
        form.addRow("Max blank lines:", self.max_blank_lines)

        root.addLayout(form)

        # ── Toggle options ────────────────────────────────────────────────
        toggles_box = QWidget()
        toggles_box.setStyleSheet("QWidget{background:#F7F7F7;border-radius:5px;}")
        tlay = QVBoxLayout(toggles_box)
        tlay.setContentsMargins(10, 8, 10, 8)
        tlay.setSpacing(4)

        def _chk(label, key, tip=""):
            cb = QCheckBox(label)
            cb.setChecked(self.opts[key])
            cb.setToolTip(tip)
            tlay.addWidget(cb)
            return cb

        self.chk_ops   = _chk("Space around operators ( == ~= <= >= .. )", "space_operators")
        self.chk_comma = _chk("Space after commas",                         "space_after_comma")
        self.chk_trail = _chk("Strip trailing whitespace",                  "trailing_whitespace")
        self.chk_norm  = _chk("Normalize minimum indent to zero",           "normalize_min_indent",
                               "Shift whole block left so the shallowest line has no leading spaces")
        self.chk_semi  = _chk("Remove standalone semicolons",               "semicolon_removal")
        self.chk_nl_end= _chk("Blank line before 'end'",                    "newline_before_end")
        self.chk_align = _chk("Align consecutive local assignments ( = )",  "align_assignments")

        root.addWidget(toggles_box)

        # ── Shape Mode ────────────────────────────────────────────────────
        sep1 = QWidget(); sep1.setFixedHeight(1)
        sep1.setStyleSheet("background-color:#CCCCCC;")
        root.addWidget(sep1)

        shape_header = QHBoxLayout()
        self.chk_shape = QCheckBox("🎨  Shape Mode  —  reflow code tokens into a silhouette")
        self.chk_shape.setStyleSheet("font-weight:bold; color:#C00080;")
        self.chk_shape.setChecked(self.opts.get("shape_mode", False))
        self.chk_shape.stateChanged.connect(self._toggle_shape_panel)
        shape_header.addWidget(self.chk_shape)
        root.addLayout(shape_header)

        # Shape options panel (shown/hidden)
        self._shape_panel = QWidget()
        sp_lay = QVBoxLayout(self._shape_panel)
        sp_lay.setContentsMargins(12, 4, 12, 4)
        sp_lay.setSpacing(6)

        shape_pick_row = QHBoxLayout()
        shape_pick_row.addWidget(QLabel("Shape:"))
        self.shape_combo = QComboBox()
        self.shape_combo.addItems(list(self.SHAPES.keys()))
        self.shape_combo.setCurrentText(self.opts.get("shape_name", "Among Us"))
        self.shape_combo.currentTextChanged.connect(self._on_shape_changed)
        shape_pick_row.addWidget(self.shape_combo)

        shape_pick_row.addWidget(QLabel("  Width:"))
        self.shape_width = QSpinBox()
        self.shape_width.setRange(40, 300)
        self.shape_width.setValue(self.opts.get("shape_width", 120))
        self.shape_width.setSuffix(" chars")
        shape_pick_row.addWidget(self.shape_width)
        shape_pick_row.addStretch()
        sp_lay.addLayout(shape_pick_row)

        # Preview label
        self._preview_label = QLabel()
        self._preview_label.setFont(QFont("Consolas", 7))
        self._preview_label.setStyleSheet(
            "background:#1a1a1a; color:#00FF88; padding:6px; border-radius:4px;")
        self._preview_label.setWordWrap(False)
        self._preview_label.setTextFormat(Qt.TextFormat.PlainText)
        sp_lay.addWidget(self._preview_label)

        # Custom shape input
        self._custom_label = QLabel("Paste your ASCII art below (use any non-space char for filled cells):")
        sp_lay.addWidget(self._custom_label)
        self._custom_input = QPlainTextEdit()
        self._custom_input.setFont(QFont("Consolas", 8))
        self._custom_input.setMaximumHeight(120)
        self._custom_input.setPlainText(self.opts.get("shape_custom", ""))
        self._custom_input.setPlaceholderText(
            "Example:\n"
            "  ###  \n"
            " ##### \n"
            "#######\n"
            " ##### \n"
            "  ###  "
        )
        sp_lay.addWidget(self._custom_input)

        root.addWidget(self._shape_panel)

        # ── Buttons ───────────────────────────────────────────────────────
        btn_row = QHBoxLayout()
        btn_reset  = QPushButton("Reset Defaults")
        btn_reset.clicked.connect(self._reset_defaults)
        btn_ok     = QPushButton("Format")
        btn_ok.setStyleSheet("background-color:#D6EAF8;font-weight:bold;")
        btn_cancel = QPushButton("Cancel")
        btn_ok.clicked.connect(self.accept)
        btn_cancel.clicked.connect(self.reject)
        btn_row.addWidget(btn_reset)
        btn_row.addStretch()
        btn_row.addWidget(btn_cancel)
        btn_row.addWidget(btn_ok)
        root.addLayout(btn_row)

        # Initial state
        self._on_shape_changed(self.shape_combo.currentText())
        self._toggle_shape_panel(self.chk_shape.checkState())

    # ── Shape panel helpers ───────────────────────────────────────────────
    def _toggle_shape_panel(self, state):
        self._shape_panel.setVisible(bool(state))
        self.adjustSize()

    def _on_shape_changed(self, name):
        is_custom = (name == "Custom")
        self._custom_label.setVisible(is_custom)
        self._custom_input.setVisible(is_custom)
        self._update_preview()

    def _update_preview(self):
        name = self.shape_combo.currentText()
        if name == "Custom":
            lines = self._custom_input.toPlainText().split('\n')
            rows = [l for l in lines if l.strip()]
        else:
            rows = self.SHAPES.get(name, [])
        if not rows:
            self._preview_label.setText("(no shape)")
            return
        # Show a tiny preview using block chars
        preview = '\n'.join(
            row.replace('#', '█').replace(' ', '·') for row in rows[:20]
        )
        self._preview_label.setText(preview)

    # ── Standard helpers ──────────────────────────────────────────────────
    def _sync_indent_size_state(self, style):
        self.indent_size.setEnabled(style == "spaces")

    def _apply_preset(self, name):
        merged = dict(self.DEFAULTS)
        merged.update(self.PRESETS.get(name, {}))
        self.indent_style.setCurrentText(merged["indent_style"])
        self.indent_size.setValue(merged["indent_size"])
        self.max_blank_lines.setValue(merged["max_blank_lines"])
        self.chk_ops.setChecked(merged["space_operators"])
        self.chk_comma.setChecked(merged["space_after_comma"])
        self.chk_trail.setChecked(merged["trailing_whitespace"])
        self.chk_norm.setChecked(merged["normalize_min_indent"])
        self.chk_semi.setChecked(merged["semicolon_removal"])
        self.chk_nl_end.setChecked(merged["newline_before_end"])
        self.chk_align.setChecked(merged["align_assignments"])

    def _reset_defaults(self):
        self._apply_preset("Default")
        self.preset_combo.setCurrentText("Default")
        self.chk_shape.setChecked(False)
        self.shape_combo.setCurrentText("Among Us")
        self.shape_width.setValue(120)
        self._custom_input.setPlainText("")

    def get_options(self) -> dict:
        return {
            "indent_style":         self.indent_style.currentText(),
            "indent_size":          self.indent_size.value(),
            "max_blank_lines":      self.max_blank_lines.value(),
            "space_operators":      self.chk_ops.isChecked(),
            "space_after_comma":    self.chk_comma.isChecked(),
            "trailing_whitespace":  self.chk_trail.isChecked(),
            "normalize_min_indent": self.chk_norm.isChecked(),
            "semicolon_removal":    self.chk_semi.isChecked(),
            "newline_before_end":   self.chk_nl_end.isChecked(),
            "align_assignments":    self.chk_align.isChecked(),
            "shape_mode":           self.chk_shape.isChecked(),
            "shape_name":           self.shape_combo.currentText(),
            "shape_custom":         self._custom_input.toPlainText(),
            "shape_width":          self.shape_width.value(),
        }


# --- Settings Dialog ---
class SettingsDialog(QDialog):
    def __init__(self, parent=None, current_theme="Light", current_font_size=11):
        super().__init__(parent)
        self.setWindowTitle("Settings")
        self.setModal(True)
        self.setMinimumWidth(400)

        layout = QFormLayout()

        # Font size
        self.font_size = QSpinBox()
        self.font_size.setRange(8, 24)
        self.font_size.setValue(current_font_size)
        layout.addRow("Font Size:", self.font_size)

        # Theme — now fully functional
        self.theme = QComboBox()
        self.theme.addItems(["Light", "Dark"])
        self.theme.setCurrentText(current_theme)
        layout.addRow("Theme:", self.theme)

        # Buttons
        btn_layout = QHBoxLayout()
        btn_ok = QPushButton("OK")
        btn_cancel = QPushButton("Cancel")
        btn_ok.clicked.connect(self.accept)
        btn_cancel.clicked.connect(self.reject)
        btn_layout.addWidget(btn_ok)
        btn_layout.addWidget(btn_cancel)

        layout.addRow(btn_layout)
        self.setLayout(layout)


# --- Find & Replace Dialog ---
class FindReplaceDialog(QDialog):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle("Find & Replace")
        self.setModal(False)
        self.setMinimumWidth(450)
        
        layout = QVBoxLayout()
        
        # Find section
        find_layout = QHBoxLayout()
        find_label = QLabel("Find:")
        find_label.setMinimumWidth(60)
        self.find_input = QTextEdit()
        self.find_input.setMaximumHeight(30)
        find_layout.addWidget(find_label)
        find_layout.addWidget(self.find_input)
        layout.addLayout(find_layout)
        
        # Replace section
        replace_layout = QHBoxLayout()
        replace_label = QLabel("Replace:")
        replace_label.setMinimumWidth(60)
        self.replace_input = QTextEdit()
        self.replace_input.setMaximumHeight(30)
        replace_layout.addWidget(replace_label)
        replace_layout.addWidget(self.replace_input)
        layout.addLayout(replace_layout)
        
        # Options
        options_layout = QHBoxLayout()
        self.case_sensitive = QCheckBox("Case Sensitive")
        self.whole_word = QCheckBox("Whole Words")
        options_layout.addWidget(self.case_sensitive)
        options_layout.addWidget(self.whole_word)
        options_layout.addStretch()
        layout.addLayout(options_layout)
        
        # Buttons
        btn_layout = QHBoxLayout()
        
        self.btn_find_next = QPushButton("Find Next")
        self.btn_find_prev = QPushButton("Find Previous")
        self.btn_replace = QPushButton("Replace")
        self.btn_replace_all = QPushButton("Replace All")
        btn_close = QPushButton("Close")
        
        btn_close.clicked.connect(self.close)
        
        btn_layout.addWidget(self.btn_find_next)
        btn_layout.addWidget(self.btn_find_prev)
        btn_layout.addWidget(self.btn_replace)
        btn_layout.addWidget(self.btn_replace_all)
        btn_layout.addStretch()
        btn_layout.addWidget(btn_close)
        
        layout.addLayout(btn_layout)
        
        # Status label
        self.status_label = QLabel("")
        self.status_label.setStyleSheet("color: #666666; font-size: 9pt;")
        layout.addWidget(self.status_label)
        
        self.setLayout(layout)


# --- Obfuscator Dialog ---
class MonacoEditor(QWebEngineView):
    """
    QWebEngineView wrapper that hosts Monaco.html.
    Provides synchronous get_text() / set_text() via a blocking QEventLoop,
    plus async set_text_async() for fire-and-forget writes.
    Also carries an optional .file_path attribute just like the old CodeEditor.
    """

    # Path to Monaco.html — sits alongside this script by default.
    MONACO_HTML = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Monaco.html")

    def __init__(self, parent=None):
        super().__init__(parent)
        self.file_path = None          # mirrors old CodeEditor.file_path
        self._ready   = False          # True once Monaco JS has initialised

        # Allow local file access so Monaco can load its VS files
        settings = self.settings()
        settings.setAttribute(QWebEngineSettings.WebAttribute.LocalContentCanAccessRemoteUrls, True)
        settings.setAttribute(QWebEngineSettings.WebAttribute.JavascriptEnabled, True)

        self.loadFinished.connect(self._on_load_finished)

        if os.path.exists(self.MONACO_HTML):
            self.load(QUrl.fromLocalFile(self.MONACO_HTML))
        else:
            # Fallback: blank page with a warning so the user knows what's wrong
            self.setHtml(
                "<body style='background:#1e1e1e;color:#f44;font-family:Consolas'>"
                "<h3>Monaco.html not found</h3>"
                f"<p>Expected: {self.MONACO_HTML}</p></body>"
            )

    def _on_load_finished(self, ok):
        # Give Monaco's require() a moment to finish registering globals
        QTimer.singleShot(300, lambda: setattr(self, '_ready', True))

    # ── public API ──────────────────────────────────────────────────────────

    def get_text(self) -> str:
        """Synchronously retrieve the editor contents."""
        if not self._ready:
            return ""
        result = [""]
        loop   = QEventLoop()

        def _cb(val):
            # runJavaScript returns the JS value; GetText() returns a plain string
            result[0] = val if isinstance(val, str) else ""
            loop.quit()

        self.page().runJavaScript("GetText()", _cb)
        loop.exec()
        return result[0]

    def set_text(self, text: str):
        """Synchronously set the editor contents."""
        if not self._ready:
            # Queue for after ready
            QTimer.singleShot(400, lambda: self.set_text(text))
            return
        escaped = (text
                   .replace("\\", "\\\\")
                   .replace("`",  "\\`")
                   .replace("$",  "\\$"))
        self.page().runJavaScript(f"SetText(`{escaped}`)")

    def set_text_async(self, text: str):
        """Fire-and-forget version of set_text (no event-loop spin)."""
        self.set_text(text)

    def set_monaco_theme(self, theme_name: str):
        """
        Map LuaBox theme names to Monaco theme names and apply.
        Dark  → PDark  (the rich PDark theme already in Monaco.html)
        Light → net-theme-light
        """
        mapping = {"Dark": "PDark", "Light": "net-theme-light"}
        monaco_theme = mapping.get(theme_name, "PDark")
        if self._ready:
            self.page().runJavaScript(f"SetTheme('{monaco_theme}')")
        else:
            QTimer.singleShot(400, lambda: self.page().runJavaScript(f"SetTheme('{monaco_theme}')"))

    def set_font_size(self, size: int):
        if self._ready:
            self.page().runJavaScript(f"SwitchFontSize({size})")

    # ── compatibility shims so callers don't need changing ──────────────────

    def toPlainText(self) -> str:
        return self.get_text()

    def setPlainText(self, text: str):
        self.set_text(text)

    def clear(self):
        self.set_text("")

    # find() / textCursor() / setTextCursor() — these were used by the old
    # QPlainTextEdit-based find-replace; with Monaco we delegate to its
    # built-in Ctrl+H / Ctrl+F or do JS-side replacement.  We implement
    # stubs that always return False so callers degrade gracefully.
    def find(self, *args, **kwargs):
        return False

    def textCursor(self):
        return _FakeCursor()

    def setTextCursor(self, cur):
        pass

    def setFocus(self):
        super().setFocus()
        # Also give focus to the embedded page so Monaco key-events work
        self.page().runJavaScript("editor && editor.focus()")


class _FakeCursor:
    """Minimal stand-in for QTextCursor so old code doesn't crash."""
    def hasSelection(self):  return False
    def insertText(self, t): pass
    def position(self):      return 0
    def setPosition(self, p): pass
    def movePosition(self, *a): pass


# --- Main Application Window ---
class _BridgeSettingsDialog(QDialog):
    def __init__(self, parent=None, pipe="", auto_push=False, ext_path=""):
        super().__init__(parent)
        self.setWindowTitle("DLL Bridge Settings")
        self.setMinimumWidth(500)
        lay = QVBoxLayout(self)
        lay.setSpacing(10)

        lay.addWidget(QLabel("<b>Pipe / Socket Path</b>"))
        pr = QHBoxLayout()
        self._pipe = QLineEdit(pipe)
        self._pipe.setPlaceholderText("\\\\.\\pipe\\LuaBoxBridge  or  /tmp/luabox.sock")
        pr.addWidget(self._pipe)
        bt = QPushButton("Test")
        bt.setFixedWidth(52)
        bt.clicked.connect(self._test)
        pr.addWidget(bt)
        lay.addLayout(pr)
        self._status = QLabel("")
        self._status.setStyleSheet("font-size:9pt;")
        lay.addWidget(self._status)

        _sep = lambda: (lambda w: (w.setFixedHeight(1), w.setStyleSheet("background:#555;"), w))(QWidget())[2]
        lay.addWidget(_sep())

        self._auto = QCheckBox("Auto-push to executor on every Save (Ctrl+S)")
        self._auto.setChecked(auto_push)
        lay.addWidget(self._auto)

        lay.addWidget(_sep())
        lay.addWidget(QLabel("<b>External Edit -- Watch File</b>"))
        _nl = QLabel("Watch a .lua file on disk. Any time it is saved by an external editor, LuaBox auto-pushes it to the executor.")
        _nl.setWordWrap(True)
        lay.addWidget(_nl)

        er = QHBoxLayout()
        self._ext = QLineEdit(ext_path)
        self._ext.setPlaceholderText("Path to .lua file to watch...")
        er.addWidget(self._ext)
        bb = QPushButton("Browse...")
        bb.setFixedWidth(70)
        bb.clicked.connect(self._browse)
        er.addWidget(bb)
        lay.addLayout(er)

        lay.addWidget(_sep())
        note = QLabel("<b>DLL protocol:</b> open the pipe name above, read 4-byte LE uint32 = script length, then read that many UTF-8 bytes. Pass the string to your internal execute function.")
        note.setWordWrap(True)
        note.setTextFormat(Qt.TextFormat.RichText)
        lay.addWidget(note)

        br = QHBoxLayout()
        ok_btn = QPushButton("Save"); ok_btn.clicked.connect(self.accept)
        cn_btn = QPushButton("Cancel"); cn_btn.clicked.connect(self.reject)
        br.addStretch(); br.addWidget(ok_btn); br.addWidget(cn_btn)
        lay.addLayout(br)

    def _test(self):
        pipe = self._pipe.text().strip()
        try:
            data = struct.pack("<I", 0)
            if sys.platform == "win32":
                import ctypes, ctypes.wintypes as wt
                h = ctypes.windll.kernel32.CreateFileW(pipe, 0x40000000, 0, None, 3, 0, None)
                if h == wt.HANDLE(-1).value: raise OSError("Pipe not found")
                ctypes.windll.kernel32.CloseHandle(h)
            else:
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
                    s.settimeout(1.5); s.connect(pipe)
            self._status.setText("✓  Connected")
            self._status.setStyleSheet("color:#3fb950;font-size:9pt;")
        except Exception as e:
            self._status.setText(f"✗  {e}")
            self._status.setStyleSheet("color:#f85149;font-size:9pt;")

    def _browse(self):
        p, _ = QFileDialog.getOpenFileName(self, "Watch file", "", "Lua Files (*.lua *.luau);;All Files (*)")
        if p: self._ext.setText(p)

    def get_config(self):
        return {"pipe": self._pipe.text().strip(),
                "auto_push": self._auto.isChecked(),
                "ext_path": self._ext.text().strip()}


class LuaIDE(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("LuaBox v4")
        self.setGeometry(100, 100, 1400, 850)
        
        self.current_file = None
        self.current_directory = QDir.homePath()
        
        # Recent files tracking
        self.recent_files = []
        self.max_recent_files = 10
        self.load_recent_files()
        
        # Find & Replace dialog
        self.find_replace_dialog = None

        # Bridge state
        self._bridge_pipe      = "\\\\.\\pipe\\LuaBoxBridge" if sys.platform == "win32" else "/tmp/luabox.sock"
        self._bridge_auto_push = False
        self._bridge_ext_path  = ""
        self._bridge_watcher   = QFileSystemWatcher(self)
        self._bridge_watcher.fileChanged.connect(self._bridge_ext_changed)

        # Theme state
        self._current_theme = "Light"
        self._current_font_size = 11

        # Set light theme
        self._apply_app_stylesheet("Light")


        # --- Main Layout ---
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        main_layout = QVBoxLayout(central_widget)
        main_layout.setContentsMargins(0, 0, 0, 0)
        main_layout.setSpacing(0)

        # --- Menu Bar / Toolbar ---
        self._toolbar_widget = QWidget()
        self._toolbar_widget.setMaximumHeight(35)
        toolbar_layout = QHBoxLayout(self._toolbar_widget)
        toolbar_layout.setContentsMargins(3, 3, 3, 3)
        toolbar_layout.setSpacing(3)
        
        btn_new = QPushButton("New")
        btn_new.clicked.connect(self.new_file)
        
        btn_open = QPushButton("Open")
        btn_open.clicked.connect(self.open_file)
        
        btn_save = QPushButton("Save")
        btn_save.clicked.connect(self.save_file)
        
        # Separator helper — stored so we can restyle on theme change
        self._separators = []
        def create_separator():
            sep = QWidget()
            sep.setFixedWidth(1)
            sep.setFixedHeight(22)
            self._separators.append(sep)
            return sep

        self._btn_settings = QPushButton("Settings")
        self._btn_settings.clicked.connect(self.show_settings)

        self._btn_format = QPushButton("Format Code")
        self._btn_format.clicked.connect(self.format_current_code)
        self._btn_format.setToolTip("Format / Beautify Lua code  (Ctrl+Shift+F)")
        from PyQt6.QtGui import QShortcut, QKeySequence
        QShortcut(QKeySequence("Ctrl+Shift+F"), self).activated.connect(self.format_current_code)
        QShortcut(QKeySequence("Ctrl+Return"), self).activated.connect(self._bridge_push)

        btn_strip = QPushButton("Remove Comments")
        btn_strip.clicked.connect(self.remove_comments)

        btn_find_replace = QPushButton("Find & Replace")
        btn_find_replace.clicked.connect(self.show_find_replace)

        
        # Recent files dropdown button
        self.btn_recent = QPushButton("Recent Files ▼")
        self.btn_recent.clicked.connect(self.show_recent_files_menu)

        toolbar_layout.addWidget(btn_new)
        toolbar_layout.addWidget(btn_open)
        toolbar_layout.addWidget(btn_save)
        toolbar_layout.addWidget(self.btn_recent)
        toolbar_layout.addWidget(create_separator())
        toolbar_layout.addWidget(btn_find_replace)
        toolbar_layout.addWidget(create_separator())
        toolbar_layout.addWidget(self._btn_settings)
        toolbar_layout.addWidget(create_separator())
        toolbar_layout.addWidget(btn_strip)
        toolbar_layout.addWidget(self._btn_format)
        toolbar_layout.addWidget(create_separator())
        self._btn_bridge_push = QPushButton("\u25b6  Push Script")
        self._btn_bridge_push.setToolTip("Send current script to executor via pipe/socket  (Ctrl+Return)")
        self._btn_bridge_push.clicked.connect(self._bridge_push)
        toolbar_layout.addWidget(self._btn_bridge_push)
        self._btn_bridge_cfg = QPushButton("\u2699  Bridge")
        self._btn_bridge_cfg.setToolTip("Configure DLL bridge / external edit settings")
        self._btn_bridge_cfg.clicked.connect(self._bridge_show_settings)
        toolbar_layout.addWidget(self._btn_bridge_cfg)
        self._lbl_bridge_status = QLabel("\u25cf")
        self._lbl_bridge_status.setToolTip("Bridge: not connected")
        self._lbl_bridge_status.setStyleSheet("color: #888; font-size: 10pt;")
        toolbar_layout.addWidget(self._lbl_bridge_status)
        toolbar_layout.addStretch()

        main_layout.addWidget(self._toolbar_widget)

        # --- Main Content Area ---
        content_splitter = QSplitter(Qt.Orientation.Horizontal)
        
        # --- File Explorer ---
        explorer_widget = QWidget()
        explorer_widget.setMaximumWidth(250)
        explorer_layout = QVBoxLayout(explorer_widget)
        explorer_layout.setContentsMargins(0, 0, 0, 0)
        
        # Create tab widget for Explorer and Templates
        self._left_panel_tabs = QTabWidget()

        # Explorer Tab
        explorer_tab = QWidget()
        explorer_tab_layout = QVBoxLayout(explorer_tab)
        explorer_tab_layout.setContentsMargins(0, 0, 0, 0)

        self._explorer_header = QWidget()
        self._explorer_header.setMaximumHeight(30)
        explorer_header_layout = QHBoxLayout(self._explorer_header)
        explorer_header_layout.setContentsMargins(5, 2, 5, 2)
        
        self._explorer_label = QLabel("Explorer")
        self._explorer_label.setStyleSheet("font-weight: bold;")

        btn_browse = QPushButton("📁")
        btn_browse.setMaximumWidth(30)
        btn_browse.setToolTip("Browse for directory")
        btn_browse.clicked.connect(self.browse_directory)



        
        btn_refresh = QPushButton("⟳")
        btn_refresh.setMaximumWidth(30)
        btn_refresh.setToolTip("Refresh explorer")
        btn_refresh.clicked.connect(self.refresh_explorer)
        
        explorer_header_layout.addWidget(self._explorer_label)
        explorer_header_layout.addStretch()
        explorer_header_layout.addWidget(btn_browse)
        explorer_header_layout.addWidget(btn_refresh)

        self.file_tree = QTreeWidget()
        self.file_tree.setHeaderLabels(["Name", "Size"])
        self.file_tree.setColumnWidth(0, 150)
        self.file_tree.itemDoubleClicked.connect(self.tree_item_double_clicked)
        self.file_tree.itemExpanded.connect(self.tree_item_expanded)
        self.file_tree.setContextMenuPolicy(Qt.ContextMenuPolicy.CustomContextMenu)
        self.file_tree.customContextMenuRequested.connect(self.show_tree_context_menu)
        
        explorer_tab_layout.addWidget(self._explorer_header)
        explorer_tab_layout.addWidget(self.file_tree)
        
        # Templates Tab
        templates_tab = QWidget()
        templates_tab_layout = QVBoxLayout(templates_tab)
        templates_tab_layout.setContentsMargins(5, 5, 5, 5)
        
        # Templates tree
        self.templates_tree = QTreeWidget()
        self.templates_tree.setHeaderLabel("Audit Templates")
        self.templates_tree.itemDoubleClicked.connect(self.insert_template)
        self.populate_templates()
        
        templates_tab_layout.addWidget(self.templates_tree)
        
        # Add tabs
        self._left_panel_tabs.addTab(explorer_tab, "Files")
        self._left_panel_tabs.addTab(templates_tab, "Templates")

        explorer_layout.addWidget(self._left_panel_tabs)
        
        # --- Editor Area ---
        editor_widget = QWidget()
        editor_layout = QVBoxLayout(editor_widget)
        editor_layout.setContentsMargins(0, 0, 0, 0)
        editor_layout.setSpacing(0)
        
        # Tab widget for multiple files
        self.tab_widget = QTabWidget()
        self.tab_widget.setTabsClosable(True)
        self.tab_widget.tabCloseRequested.connect(self.close_tab)
        
        # Create initial tab
        self.create_new_tab("new")
        
        editor_layout.addWidget(self.tab_widget)
        
        content_splitter.addWidget(explorer_widget)
        content_splitter.addWidget(editor_widget)
        content_splitter.setSizes([200, 1000])

        self._vert_splitter = QSplitter(Qt.Orientation.Vertical)
        self._vert_splitter.setChildrenCollapsible(False)
        self._vert_splitter.addWidget(content_splitter)

        # Terminal dock
        term_container = QWidget()
        term_layout = QVBoxLayout(term_container)
        term_layout.setContentsMargins(0, 0, 0, 0)
        term_layout.setSpacing(0)

        term_header = QWidget()
        term_header.setFixedHeight(28)
        th_layout = QHBoxLayout(term_header)
        th_layout.setContentsMargins(6, 0, 6, 0)
        th_layout.setSpacing(6)
        self._term_title_lbl = QLabel("  TERMINAL")
        self._term_title_lbl.setStyleSheet("font-weight:bold;font-size:9pt;letter-spacing:1px;")
        th_layout.addWidget(self._term_title_lbl)
        th_layout.addStretch()
        self._term_cwd_label = QLabel("")
        self._term_cwd_label.setStyleSheet("font-size:8pt;")
        th_layout.addWidget(self._term_cwd_label)
        btn_term_clear = QPushButton("Clear")
        btn_term_clear.setFixedSize(48, 20)
        btn_term_clear.clicked.connect(self._term_clear)
        th_layout.addWidget(btn_term_clear)
        btn_term_kill = QPushButton("Kill")
        btn_term_kill.setFixedSize(38, 20)
        btn_term_kill.clicked.connect(self._term_kill)
        th_layout.addWidget(btn_term_kill)
        term_layout.addWidget(term_header)

        from PyQt6.QtGui import QFont as _QFont
        self._term_output = QPlainTextEdit()
        self._term_output.setReadOnly(True)
        self._term_output.setMaximumBlockCount(2000)
        self._term_output.setFont(_QFont("Consolas", 10))
        term_layout.addWidget(self._term_output)

        input_row = QWidget()
        in_layout = QHBoxLayout(input_row)
        in_layout.setContentsMargins(4, 2, 4, 2)
        in_layout.setSpacing(4)
        self._term_prompt = QLabel("$")
        self._term_prompt.setFixedWidth(14)
        self._term_prompt.setStyleSheet("font-family:Consolas;font-size:10pt;font-weight:bold;")
        in_layout.addWidget(self._term_prompt)
        self._term_input = QLineEdit()
        self._term_input.setFont(_QFont("Consolas", 10))
        self._term_input.setPlaceholderText("Enter command...")
        self._term_input.returnPressed.connect(self._term_run)
        in_layout.addWidget(self._term_input)
        btn_run = QPushButton("Run")
        btn_run.setFixedWidth(42)
        btn_run.clicked.connect(self._term_run)
        in_layout.addWidget(btn_run)
        term_layout.addWidget(input_row)

        self._vert_splitter.addWidget(term_container)
        self._vert_splitter.setSizes([700, 200])

        self._term_process  = None
        self._term_history  = []
        self._term_hist_idx = -1
        self._term_input.installEventFilter(self)

        main_layout.addWidget(self._vert_splitter)

        # Populate file explorer
        self.refresh_explorer()

        # Apply full theme now that all widget refs exist
        self.apply_theme(self._current_theme)

    def create_new_tab(self, title):
        """Create a new Monaco editor tab."""
        tab_container = QWidget()
        tab_layout = QVBoxLayout(tab_container)
        tab_layout.setContentsMargins(0, 0, 0, 0)

        editor = MonacoEditor()
        # Apply current theme once Monaco is ready
        QTimer.singleShot(500, lambda: editor.set_monaco_theme(self._current_theme))
        QTimer.singleShot(500, lambda: editor.set_font_size(self._current_font_size))
        tab_layout.addWidget(editor)

        index = self.tab_widget.addTab(tab_container, title)
        self.tab_widget.setCurrentIndex(index)
        return editor

    def get_current_editor(self):
        """Get the current active Monaco editor."""
        current_widget = self.tab_widget.currentWidget()
        if current_widget:
            return current_widget.findChild(MonacoEditor)
        return None

    def new_file(self):
        """Create a new file tab."""
        self.create_new_tab("new")

    def open_file(self):
        """Open a file dialog and load a file."""
        filename, _ = QFileDialog.getOpenFileName(
            self, "Open File", self.current_directory,
            "Lua Files (*.lua);;Luau Files (*.luau);;All Files (*.*)"
        )
        if filename:
            self.current_directory = os.path.dirname(filename)
            with open(filename, 'r', encoding='utf-8') as f:
                content = f.read()
            editor = self.create_new_tab(os.path.basename(filename))
            editor.file_path = filename
            QTimer.singleShot(600, lambda: editor.set_text(content))
            self.add_recent_file(filename)

    def save_file(self):
        """Save the current file."""
        editor = self.get_current_editor()
        if not editor:
            return
        if hasattr(editor, 'file_path') and editor.file_path:
            filename = editor.file_path
        else:
            filename, _ = QFileDialog.getSaveFileName(
                self, "Save File", self.current_directory,
                "Lua Files (*.lua);;Luau Files (*.luau);;All Files (*.*)"
            )
        if filename:
            content = editor.get_text()
            with open(filename, 'w', encoding='utf-8') as f:
                f.write(content)
            editor.file_path = filename
            current_index = self.tab_widget.currentIndex()
            self.tab_widget.setTabText(current_index, os.path.basename(filename))
            self.add_recent_file(filename)
            QMessageBox.information(self, "Success", "File saved successfully!")
            if self._bridge_auto_push:
                self._bridge_push(silent=True)

    def close_tab(self, index):
        """Close a tab."""
        if self.tab_widget.count() > 1:
            self.tab_widget.removeTab(index)
        else:
            # Keep at least one tab
            editor = self.get_current_editor()
            if editor:
                editor.clear()
                self.tab_widget.setTabText(0, "Untitled")

    def refresh_explorer(self):
        """Refresh the file explorer with directory tree."""
        self.file_tree.clear()
        
        # Add current path as root
        root_item = QTreeWidgetItem(self.file_tree)
        root_item.setText(0, self.current_directory)
        root_item.setText(1, "")
        root_item.setData(0, Qt.ItemDataRole.UserRole, self.current_directory)
        root_item.setExpanded(True)
        
        # Populate directory tree
        self.populate_directory_tree(root_item, self.current_directory)


    def populate_directory_tree(self, parent_item, directory_path):
        """Recursively populate directory tree."""
        try:
            directory = QDir(directory_path)
            
            # Get directories first
            dirs = directory.entryInfoList(
                QDir.Filter.Dirs | QDir.Filter.NoDotAndDotDot,
                QDir.SortFlag.Name
            )
            
            for dir_info in dirs:
                dir_item = QTreeWidgetItem(parent_item)
                dir_item.setText(0, f"📁 {dir_info.fileName()}")
                dir_item.setText(1, "<DIR>")
                dir_item.setData(0, Qt.ItemDataRole.UserRole, dir_info.absoluteFilePath())
                
                # Add placeholder for lazy loading
                placeholder = QTreeWidgetItem(dir_item)
                placeholder.setText(0, "Loading...")
            
            # Get files
            files = directory.entryInfoList(
                QDir.Filter.Files | QDir.Filter.NoDotAndDotDot,
                QDir.SortFlag.Name
            )
            
            for file_info in files:
                file_item = QTreeWidgetItem(parent_item)
                file_item.setText(0, f"📄 {file_info.fileName()}")
                size_kb = file_info.size() / 1024
                file_item.setText(1, f"{size_kb:.2f} KB")
                file_item.setData(0, Qt.ItemDataRole.UserRole, file_info.absoluteFilePath())
        
        except Exception as e:
            error_item = QTreeWidgetItem(parent_item)
            error_item.setText(0, f"Error: {str(e)}")
    
    def browse_directory(self):
        """Open dialog to browse and select a directory."""
        directory = QFileDialog.getExistingDirectory(
            self, "Select Directory", self.current_directory
        )
        if directory:
            self.current_directory = directory
            self.refresh_explorer()
    
    def show_tree_context_menu(self, position):
        """Show context menu for file tree items."""
        item = self.file_tree.itemAt(position)
        if not item:
            return
        
        filepath = item.data(0, Qt.ItemDataRole.UserRole)
        if not filepath:
            return
        
        menu = QMenu(self)
        
        # Add actions based on whether it's a file or directory
        if os.path.isfile(filepath):
            open_action = menu.addAction("Open")
            open_action.triggered.connect(lambda: self.tree_item_double_clicked(item, 0))
        
        if os.path.isdir(filepath):
            set_as_root_action = menu.addAction("Set as Root Directory")
            set_as_root_action.triggered.connect(lambda: self.set_root_directory(filepath))
        
        menu.addSeparator()
        
        copy_path_action = menu.addAction("Copy Path")
        copy_path_action.triggered.connect(lambda: QApplication.clipboard().setText(filepath))
        
        copy_name_action = menu.addAction("Copy Name")
        copy_name_action.triggered.connect(lambda: QApplication.clipboard().setText(os.path.basename(filepath)))
        
        menu.addSeparator()
        
        if os.path.exists(filepath):
            show_in_folder_action = menu.addAction("Show in Folder")
            show_in_folder_action.triggered.connect(lambda: self.show_in_system_explorer(filepath))
        
        menu.exec(self.file_tree.viewport().mapToGlobal(position))
    
    def set_root_directory(self, directory_path):
        """Set the selected directory as the root in explorer."""
        self.current_directory = directory_path
        self.refresh_explorer()
    
    def show_in_system_explorer(self, filepath):
        """Open the system file explorer at the given path."""
        try:
            if os.path.isfile(filepath):
                filepath = os.path.dirname(filepath)
            
            if sys.platform == 'win32':
                os.startfile(filepath)
            elif sys.platform == 'darwin':
                subprocess.run(['open', filepath])
            else:  # Linux and other Unix-like
                subprocess.run(['xdg-open', filepath])
        except Exception as e:
            QMessageBox.warning(self, "Error", f"Could not open folder: {str(e)}")

    def tree_item_expanded(self, item):
        """Handle tree item expansion for lazy loading."""
        # Check if this item has a placeholder child
        if item.childCount() == 1:
            child = item.child(0)
            if child.text(0) == "Loading...":
                # Remove placeholder
                item.removeChild(child)
                
                # Get the directory path
                directory_path = item.data(0, Qt.ItemDataRole.UserRole)
                
                # Populate this directory
                if directory_path and os.path.isdir(directory_path):
                    self.populate_directory_tree(item, directory_path)
    
    def tree_item_double_clicked(self, item, column):
        """Handle double-click on file explorer item."""
        filepath = item.data(0, Qt.ItemDataRole.UserRole)
        if filepath:
            if os.path.isfile(filepath):
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    editor = self.create_new_tab(os.path.basename(filepath))
                    editor.file_path = filepath
                    QTimer.singleShot(600, lambda: editor.set_text(content))
                    self.add_recent_file(filepath)
                except Exception as e:
                    QMessageBox.warning(self, "Error", f"Could not open file: {str(e)}")
            elif os.path.isdir(filepath):
                item.setExpanded(not item.isExpanded())

    def show_settings(self):
        """Show settings dialog."""
        dialog = SettingsDialog(self,
                                current_theme=self._current_theme,
                                current_font_size=self._current_font_size)
        if dialog.exec():
            new_font_size  = dialog.font_size.value()
            new_theme_name = dialog.theme.currentText()

            self._current_font_size = new_font_size

            # Apply font size to all open Monaco editors
            for i in range(self.tab_widget.count()):
                widget = self.tab_widget.widget(i)
                editor = widget.findChild(MonacoEditor)
                if editor:
                    editor.set_font_size(new_font_size)

            # Apply theme if it changed
            if new_theme_name != self._current_theme:
                self.apply_theme(new_theme_name)

    # ── Theme engine ──────────────────────────────────────────────────────────

    def _apply_app_stylesheet(self, theme_name: str):
        """Build and apply the main QSS stylesheet from the theme dict."""
        global _current_theme
        _current_theme = theme_name
        t = THEMES[theme_name]

        self.setStyleSheet(f"""
            QMainWindow, QWidget {{
                background-color: {t['app_bg']};
                color: {t['label_fg']};
            }}
            QDialog {{
                background-color: {t['app_bg']};
                color: {t['label_fg']};
            }}
            QLabel {{
                color: {t['label_fg']};
                background: transparent;
            }}
            QSpinBox, QComboBox, QLineEdit, QTextEdit {{
                background-color: {t['tree_bg']};
                color: {t['label_fg']};
                border: 1px solid {t['tree_border']};
                padding: 2px 4px;
            }}
            QCheckBox {{
                color: {t['label_fg']};
            }}
            QPushButton {{
                background-color: {t['btn_bg']};
                color: {t['btn_fg']};
                border: 1px solid {t['btn_border_out']};
                border-top: 1px solid {t['btn_border_tl']};
                border-left: 1px solid {t['btn_border_tl']};
                border-right: 1px solid {t['btn_border_br']};
                border-bottom: 1px solid {t['btn_border_br']};
                padding: 3px 10px;
                font-size: 9pt;
                min-width: 60px;
            }}
            QPushButton:hover {{
                background-color: {t['btn_hover_bg']};
                border: 1px solid {t['btn_hover_border']};
            }}
            QPushButton:pressed {{
                background-color: {t['btn_press_bg']};
            }}
            QTreeWidget {{
                background-color: {t['tree_bg']};
                color: {t['label_fg']};
                border: 1px solid {t['tree_border']};
                font-size: 9pt;
                alternate-background-color: {t['tree_alt']};
            }}
            QTreeWidget::item {{
                padding: 2px;
            }}
            QTreeWidget::item:selected {{
                background-color: {t['tree_sel_bg']};
                color: {t['tree_sel_fg']};
            }}
            QTreeWidget::item:hover {{
                background-color: {t['tree_hover']};
            }}
            QHeaderView::section {{
                background-color: {t['tab_bg']};
                color: {t['label_fg']};
                border: 1px solid {t['tree_border']};
                padding: 2px 4px;
            }}
            QTabWidget::pane {{
                border: 1px solid {t['tab_pane_border']};
                background-color: {t['tab_pane_bg']};
                top: -1px;
            }}
            QTabBar::tab {{
                background-color: {t['tab_bg']};
                color: {t['label_fg']};
                border: 1px solid {t['tab_border']};
                border-bottom: none;
                padding: 4px 10px;
                margin-right: 2px;
                font-size: 9pt;
                border-top-left-radius: 4px;
                border-top-right-radius: 4px;
                min-width: 60px;
            }}
            QTabBar::tab:selected {{
                background-color: {t['tab_sel_bg']};
                color: {t['label_fg']};
                border-bottom: 1px solid {t['tab_sel_bg']};
                margin-bottom: -1px;
            }}
            QTabBar::tab:hover {{
                background-color: {t['tab_hover_bg']};
            }}
            QTabBar::tab:!selected {{
                margin-top: 2px;
            }}
            QTabBar::close-button {{
                image: none;
                subcontrol-position: right;
                subcontrol-origin: padding;
                background-color: transparent;
                border: none;
                padding: 0px;
                margin: 2px;
            }}
            QTabBar::close-button:hover {{
                background-color: #E81123;
                border-radius: 2px;
            }}
            QScrollBar:vertical {{
                background: {t['app_bg']};
                width: 10px;
            }}
            QScrollBar::handle:vertical {{
                background: {t['tab_border']};
                border-radius: 4px;
                min-height: 20px;
            }}
            QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical {{
                height: 0px;
            }}
            QScrollBar:horizontal {{
                background: {t['app_bg']};
                height: 10px;
            }}
            QScrollBar::handle:horizontal {{
                background: {t['tab_border']};
                border-radius: 4px;
                min-width: 20px;
            }}
            QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal {{
                width: 0px;
            }}
            QStatusBar {{
                background-color: {t['toolbar_bg']};
                color: {t['status_fg']};
                border-top: 1px solid {t['toolbar_border']};
            }}
            QSplitter::handle {{
                background-color: {t['splitter_bg']};
            }}
            QMenu {{
                background-color: {t['tree_bg']};
                color: {t['label_fg']};
                border: 1px solid {t['tree_border']};
            }}
            QMenu::item:selected {{
                background-color: {t['tree_sel_bg']};
                color: {t['tree_sel_fg']};
            }}
        """)

    def apply_theme(self, theme_name: str):
        """Switch to the named theme and repaint everything."""
        global _current_theme
        self._current_theme = theme_name
        _current_theme = theme_name
        t = THEMES[theme_name]

        # 1. Main app stylesheet
        self._apply_app_stylesheet(theme_name)

        # 2. Toolbar widget
        self._toolbar_widget.setStyleSheet(
            f"background-color: {t['toolbar_bg']}; "
            f"border-bottom: 1px solid {t['toolbar_border']};"
        )

        # 3. Separator lines
        for sep in self._separators:
            sep.setStyleSheet(f"background-color: {t['btn_border_out']};")

        # 4. Accent buttons
        self._btn_settings.setStyleSheet(f"background-color: {t['btn_settings']};")
        self._btn_format.setStyleSheet(f"background-color: {t['btn_format']};")
        self._btn_bridge_push.setStyleSheet(f"background-color: {t['btn_bridge']};")
        self._btn_bridge_cfg.setStyleSheet(f"background-color: {t['btn_bridge']};")

        # 5. Explorer header
        self._explorer_header.setStyleSheet(
            f"background-color: {t['explorer_hdr_bg']}; "
            f"border-bottom: 1px solid {t['explorer_hdr_bd']};"
        )
        self._explorer_label.setStyleSheet(
            f"font-weight: bold; color: {t['label_fg']};"
        )

        # 6. Left panel tabs
        self._left_panel_tabs.setStyleSheet(f"""
            QTabWidget::pane {{
                border: 1px solid {t['tab_border']};
                background-color: {t['tab_pane_bg']};
            }}
            QTabBar::tab {{
                background-color: {t['tab_bg']};
                color: {t['label_fg']};
                border: 1px solid {t['tab_border']};
                padding: 4px 8px;
                font-size: 9pt;
            }}
            QTabBar::tab:selected {{
                background-color: {t['tab_sel_bg']};
                color: {t['label_fg']};
            }}
            QTabBar::tab:hover {{
                background-color: {t['tab_hover_bg']};
            }}
        """)

        # 7. All open editors — tell Monaco to switch theme & font size
        for i in range(self.tab_widget.count()):
            widget = self.tab_widget.widget(i)
            editor = widget.findChild(MonacoEditor)
            if editor:
                editor.set_monaco_theme(theme_name)
                editor.set_font_size(self._current_font_size)

        self.statusBar().showMessage(
            f"Theme switched to {theme_name}", 2000
        )

    def remove_comments(self):
        """Smart comment removal that preserves code structure."""
        editor = self.get_current_editor()
        if not editor:
            return
        code = editor.get_text()
        if not code.strip():
            QMessageBox.warning(self, "Empty Editor", "Editor is empty. Nothing to remove.")
            return
        try:
            cleaned_code = LuaCommentRemover.remove_comments(code)
            editor.set_text(cleaned_code)
            QMessageBox.information(
                self, "Success",
                "Comments removed intelligently.\n\nPreserved:\n"
                "• Code structure and line integrity\n"
                "• Strings containing '--' patterns\n"
                "• Code on lines with trailing comments"
            )
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Error removing comments: {str(e)}")

    def populate_templates(self):
        """Populate the templates tree with advanced audit and research templates."""
        templates_data = {
            "Security Headers": {
            'Anti-Tamper Guard': '''-- Detects metatable tampering / read-only bypasses
local function checkIntegrity()
    local mt = getrawmetatable(game)
    if not mt then warn("[Security] No metatable"); return false end
    local idx = rawget(mt, "__index")
    if type(idx) ~= "function" and type(idx) ~= "table" then
        warn("[Security] __index tampered"); return false
    end
    return true
end
if not checkIntegrity() then
    error("[Security] Integrity check failed -- aborting", 2)
end
''',
            'Anti-Debug / Decompiler Traps': '''local function isDecompilerPresent()
    local info = debug and debug.getinfo and debug.getinfo(1, "u")
    if info and info.nups and info.nups > 32 then return true end
    for _, k in ipairs({"dumpfunction","decompile","getscriptbytecode"}) do
        if _G[k] ~= nil then return true end
    end
    return false
end
if isDecompilerPresent() then return end
local _s = {}
local function _c() return _s end
assert(_c() == _s, "[Security] Closure integrity violated")
''',
            'Anti-WebSocket Detection': '''local mt = getrawmetatable(game)
local origNC = rawget(mt, "__namecall")
if origNC and iscclosure and not iscclosure(origNC) then
    warn("[Security] __namecall hook detected -- possible remote spy")
end
local _mon = {}
local function watchRemote(remote)
    if _mon[remote] then return end
    _mon[remote] = true
    if islclosure and islclosure(remote.FireServer) then
        warn("[Security] FireServer hooked on", remote:GetFullName())
    end
end
-- watchRemote(game.ReplicatedStorage:WaitForChild("SomeRemote"))
''',
            'WebSocket Block Header': '''local _bWS = setmetatable({}, {
    __index    = function(_, k) warn("[Security] WebSocket."..k.." blocked"); return function() end end,
    __newindex = function() end,
    __call     = function() warn("[Security] WebSocket() blocked"); return nil end,
})
if rawget(_G,"WebSocket")~=nil then rawset(_G,"WebSocket",_bWS) end
if rawget(_G,"websocket")~=nil then rawset(_G,"websocket",_bWS) end
local _origReq = http_request or request
local function safeRequest(opts)
    local url = (opts and opts.Url) or ""
    for _, d in ipairs({"roblox.com","robloxlabs.com"}) do
        if url:find(d,1,true) then return _origReq(opts) end
    end
    warn("[Security] Blocked:", url)
    return {StatusCode=403, Body=""}
end
http_request = safeRequest; request = safeRequest
''',
            'identifyexecutor Spoof -- Generic': '''-- Spoofs identifyexecutor to return a chosen executor name
local SPOOF_NAME = "Synapse X"
local SPOOF_VER  = "2.1.0"
local function spoofedIE() return SPOOF_NAME, SPOOF_VER end
if rawget(_G,"identifyexecutor")~=nil then rawset(_G,"identifyexecutor",spoofedIE) end
if rawget(_G,"getexecutorname")~=nil  then rawset(_G,"getexecutorname",spoofedIE)  end
''',
            'identifyexecutor Spoof -- Nil (hide executor)': '''-- Returns nil so scripts that gate on executor name get nothing
local function hiddenIE() return nil, nil end
if rawget(_G,"identifyexecutor")~=nil then rawset(_G,"identifyexecutor",hiddenIE) end
if rawget(_G,"getexecutorname")~=nil  then rawset(_G,"getexecutorname",hiddenIE)  end
''',
            'identifyexecutor Spoof -- Dynamic Table': '''local SPOOF_AS = "Synapse X"
local spoofTable = {
    ["Synapse X"]  = {"Synapse X",  "2.1.0"},
    ["KRNL"]       = {"KRNL",        "2.1.0"},
    ["Fluxus"]     = {"Fluxus",      "1.0.0"},
    ["Script-Ware"]= {"Script-Ware", "2.5.0"},
    ["Electron"]   = {"Electron",    "1.0.0"},
}
local chosen = spoofTable[SPOOF_AS] or spoofTable["Synapse X"]
local function spoofedIE() return chosen[1], chosen[2] end
if rawget(_G,"identifyexecutor")~=nil then rawset(_G,"identifyexecutor",spoofedIE) end
if rawget(_G,"getexecutorname")~=nil  then rawset(_G,"getexecutorname",spoofedIE)  end
''',
            'identifyexecutor Spoof -- genv Hook': '''-- Hooks via getgenv() -- visible script-wide, most reliable method
local genv = getgenv()
local SPOOF_NAME = "Synapse X"
local SPOOF_VER  = "2.1.0"
genv.identifyexecutor  = function() return SPOOF_NAME, SPOOF_VER end
genv.getexecutorname   = function() return SPOOF_NAME, SPOOF_VER end
genv.getexecutorversion= function() return SPOOF_VER end
''',
            },
            "Loadstring Templates": {
            'Basic HttpGet Loadstring': '''loadstring(game:HttpGet("https://raw.githubusercontent.com/User/Repo/main/script.lua"))()
''',
            'Protected Loadstring (pcall)': '''local url = "https://raw.githubusercontent.com/User/Repo/main/script.lua"
local ok, err = pcall(function()
    local src = game:HttpGet(url)
    assert(type(src)=="string" and #src>0, "Empty response")
    local fn, e = loadstring(src)
    assert(fn, "loadstring failed: "..tostring(e))
    fn()
end)
if not ok then warn("[Loader] Failed:", err) end
''',
            'Loadstring with Version Check': '''local BASE="https://raw.githubusercontent.com/User/Repo/main/"
local LOCAL_VER="1.0.0"
local ok,rv=pcall(function() return game:HttpGet(BASE.."version.txt"):match("^%S+") end)
if ok and rv and rv~=LOCAL_VER then warn("[Loader] Update -- remote:",rv,"local:",LOCAL_VER) end
local ok2,err=pcall(function() loadstring(game:HttpGet(BASE.."script.lua"))() end)
if not ok2 then warn("[Loader] Error:",err) end
''',
            'Multi-File Loader': '''local BASE="https://raw.githubusercontent.com/User/Repo/main/"
local files={"modules/utils.lua","modules/ui.lua","main.lua"}
local function loadRemote(path)
    local src=game:HttpGet(BASE..path)
    local fn,err=loadstring(src)
    if not fn then warn("[Loader] Parse error:",path,err);return end
    local ok,e=pcall(fn)
    if not ok then warn("[Loader] Runtime error:",path,e) end
end
for _,f in ipairs(files) do loadRemote(f);task.wait() end
''',
            'Loadstring with Integrity Hash': '''local url="https://raw.githubusercontent.com/User/Repo/main/script.lua"
local expected="PASTE_SHA256_HASH_HERE"
local src=game:HttpGet(url)
local function getHash(d)
    if crypt and crypt.hash then return crypt.hash(d) end
    if hashlib and hashlib.sha256 then return hashlib.sha256(d) end
end
local hash=getHash(src)
if hash and hash~=expected then error("[Loader] Integrity check FAILED!",2) end
loadstring(src)()
''',
            'require() by Asset ID': '''-- Replace 0000000000 with the actual ModuleScript asset ID
local mod=require(0000000000)
-- mod:Init()
-- mod:Start()
''',
            },
        }
        for category, templates in templates_data.items():
            category_item = QTreeWidgetItem(self.templates_tree)
            category_item.setText(0, category)
            category_item.setExpanded(False)
            
            for name, code in templates.items():
                template_item = QTreeWidgetItem(category_item)
                template_item.setText(0, name)
                template_item.setData(0, Qt.ItemDataRole.UserRole, code)

    def insert_template(self, item, column):
        """Insert selected template into the current Monaco editor."""
        template_code = item.data(0, Qt.ItemDataRole.UserRole)
        if not template_code:
            return
        editor = self.get_current_editor()
        if not editor:
            return
        # Append template at the end of whatever is already in the editor
        existing = editor.get_text()
        separator = "\n\n" if existing.strip() else ""
        editor.set_text(existing + separator + template_code)
        editor.setFocus()
    
    # --- Find & Replace Methods ---
    def show_find_replace(self):
        """Show the Find & Replace dialog."""
        if not self.find_replace_dialog:
            self.find_replace_dialog = FindReplaceDialog(self)
            
            # Connect buttons to methods
            self.find_replace_dialog.btn_find_next.clicked.connect(self.find_next)
            self.find_replace_dialog.btn_find_prev.clicked.connect(self.find_previous)
            self.find_replace_dialog.btn_replace.clicked.connect(self.replace_current)
            self.find_replace_dialog.btn_replace_all.clicked.connect(self.replace_all)
        
        self.find_replace_dialog.show()
        self.find_replace_dialog.raise_()
        self.find_replace_dialog.activateWindow()
    
    def find_next(self):
        """Trigger Monaco's built-in find widget (next)."""
        if not self.find_replace_dialog:
            return
        editor = self.get_current_editor()
        if not editor:
            return
        search_text = self.find_replace_dialog.find_input.toPlainText()
        if not search_text:
            self.find_replace_dialog.status_label.setText("Please enter text to find")
            return
        case = str(self.find_replace_dialog.case_sensitive.isChecked()).lower()
        whole = str(self.find_replace_dialog.whole_word.isChecked()).lower()
        esc = search_text.replace("\\", "\\\\").replace("`", "\\`").replace("$", "\\$")
        js = (
            f"editor.getAction('actions.find').run();"
            f"editor.trigger('', 'editor.action.nextMatchFindAction', {{}});"
        )
        # Use Monaco's IFindController API for case/word options
        js_full = f"""
(function() {{
    var c = editor.getContribution('editor.contrib.findController');
    if (c) {{
        c.start({{
            forceRevealReplace: false,
            seedSearchStringFromSelection: 'never',
            shouldFocus: 0,
            shouldAnimate: false,
            updateSearchScope: false,
            loop: true
        }});
        c.setSearchString(`{esc}`);
        c.find(false);
    }}
}})();
"""
        editor.page().runJavaScript(js_full)
        self.find_replace_dialog.status_label.setText(f"Searching: {search_text}")

    def find_previous(self):
        """Trigger Monaco's built-in find widget (previous)."""
        if not self.find_replace_dialog:
            return
        editor = self.get_current_editor()
        if not editor:
            return
        search_text = self.find_replace_dialog.find_input.toPlainText()
        if not search_text:
            self.find_replace_dialog.status_label.setText("Please enter text to find")
            return
        esc = search_text.replace("\\", "\\\\").replace("`", "\\`").replace("$", "\\$")
        js_full = f"""
(function() {{
    var c = editor.getContribution('editor.contrib.findController');
    if (c) {{
        c.setSearchString(`{esc}`);
        c.find(true);
    }}
}})();
"""
        editor.page().runJavaScript(js_full)
        self.find_replace_dialog.status_label.setText(f"Searching: {search_text}")
    
    def replace_current(self):
        """Replace the first occurrence of the search text from cursor onward."""
        if not self.find_replace_dialog:
            return
        editor = self.get_current_editor()
        if not editor:
            return
        search_text  = self.find_replace_dialog.find_input.toPlainText()
        replace_text = self.find_replace_dialog.replace_input.toPlainText()
        if not search_text:
            self.find_replace_dialog.status_label.setText("Please enter text to find")
            return
        code = editor.get_text()
        idx  = code.find(search_text)
        if idx == -1:
            self.find_replace_dialog.status_label.setText(f"Not found: {search_text}")
            return
        new_code = code[:idx] + replace_text + code[idx + len(search_text):]
        editor.set_text(new_code)
        self.find_replace_dialog.status_label.setText("Replaced 1 occurrence")

    def replace_all(self):
        """Replace all occurrences of the search text."""
        if not self.find_replace_dialog:
            return
        editor = self.get_current_editor()
        if not editor:
            return
        search_text  = self.find_replace_dialog.find_input.toPlainText()
        replace_text = self.find_replace_dialog.replace_input.toPlainText()
        if not search_text:
            self.find_replace_dialog.status_label.setText("Please enter text to find")
            return
        code  = editor.get_text()
        flags = 0 if self.find_replace_dialog.case_sensitive.isChecked() else re.IGNORECASE
        pat   = re.escape(search_text)
        if self.find_replace_dialog.whole_word.isChecked():
            pat = r'\b' + pat + r'\b'
        new_code, count = re.subn(pat, lambda m: replace_text, code, flags=flags)
        editor.set_text(new_code)
        self.find_replace_dialog.status_label.setText(f"Replaced {count} occurrence(s)")
    
    # --- Recent Files Methods ---
    def load_recent_files(self):
        """Load recent files from a config file."""
        config_file = os.path.join(os.path.expanduser("~"), ".luabox_recent")
        if os.path.exists(config_file):
            try:
                with open(config_file, 'r') as f:
                    self.recent_files = [line.strip() for line in f.readlines() if line.strip()]
                    self.recent_files = self.recent_files[:self.max_recent_files]
            except:
                pass
    
    def save_recent_files(self):
        """Save recent files to a config file."""
        config_file = os.path.join(os.path.expanduser("~"), ".luabox_recent")
        try:
            with open(config_file, 'w') as f:
                for filepath in self.recent_files:
                    f.write(filepath + '\n')
        except:
            pass
    
    def add_recent_file(self, filepath):
        """Add a file to the recent files list."""
        # Remove if already exists
        if filepath in self.recent_files:
            self.recent_files.remove(filepath)
        
        # Add to beginning
        self.recent_files.insert(0, filepath)
        
        # Keep only max recent files
        self.recent_files = self.recent_files[:self.max_recent_files]
        
        # Save to disk
        self.save_recent_files()
    
    def show_recent_files_menu(self):
        """Show a dropdown menu with recent files."""
        if not self.recent_files:
            QMessageBox.information(self, "No Recent Files", "No recent files to display.")
            return
        
        menu = QMenu(self)
        
        for filepath in self.recent_files:
            if os.path.exists(filepath):
                filename = os.path.basename(filepath)
                action = menu.addAction(filename)
                action.setData(filepath)
                action.triggered.connect(lambda checked, path=filepath: self.open_recent_file(path))
            else:
                # File doesn't exist anymore, show grayed out
                filename = os.path.basename(filepath) + " (missing)"
                action = menu.addAction(filename)
                action.setEnabled(False)
        
        menu.addSeparator()
        clear_action = menu.addAction("Clear Recent Files")
        clear_action.triggered.connect(self.clear_recent_files)
        
        # Show menu at button position
        menu.exec(self.btn_recent.mapToGlobal(self.btn_recent.rect().bottomLeft()))
    
    def open_recent_file(self, filepath):
        """Open a file from the recent files list."""
        if os.path.exists(filepath):
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                editor = self.create_new_tab(os.path.basename(filepath))
                editor.file_path = filepath
                QTimer.singleShot(600, lambda: editor.set_text(content))
                self.add_recent_file(filepath)
            except Exception as e:
                QMessageBox.critical(self, "Error", f"Failed to open file: {str(e)}")

    def format_current_code(self):
        """Show format-options dialog, then format the code in the current editor tab."""
        editor = self.get_current_editor()
        if not editor:
            return
        code = editor.get_text()
        if not code.strip():
            QMessageBox.information(self, "Format Code", "No code to format.")
            return
        if not hasattr(self, '_last_format_options'):
            self._last_format_options = None
        dialog = FormatOptionsDialog(self, self._last_format_options)
        if not dialog.exec():
            return
        options = dialog.get_options()
        self._last_format_options = options
        try:
            formatted_code = self.format_lua_code(code, options)
            editor.set_text(formatted_code)
            self.statusBar().showMessage("Code formatted successfully", 3000)
        except Exception as e:
            QMessageBox.warning(self, "Format Error", f"Error formatting code: {str(e)}")

    def format_lua_code(self, code, options: dict = None):
        """
        Lua beautifier / formatter with customisable options.

        Options dict (see FormatOptionsDialog.DEFAULTS for keys):
          indent_style         – 'spaces' | 'tabs'
          indent_size          – int 1-8 (ignored when style=tabs)
          max_blank_lines      – int 0-5
          space_operators      – bool  (== ~= <= >= ..)
          space_after_comma    – bool
          trailing_whitespace  – bool  (strip trailing spaces)
          normalize_min_indent – bool  (shift block left so min indent = 0)
          semicolon_removal    – bool  (remove standalone ';' lines)
          newline_before_end   – bool  (insert blank line before 'end')
          align_assignments    – bool  (align '=' in consecutive local lines)
          shape_mode           – bool  (reflow tokens into a silhouette shape)
          shape_name           – str   (shape key from FormatOptionsDialog.SHAPES)
          shape_custom         – str   (raw ASCII art for Custom shape)
          shape_width          – int   (target character width of the shape)
        """
        import re

        if options is None:
            options = dict(FormatOptionsDialog.DEFAULTS)

        # ── Shape mode bypasses normal indentation entirely ───────────────
        if options.get('shape_mode'):
            return self._shape_format_code(code, options)

        indent_unit  = ('\t' if options.get('indent_style') == 'tabs'
                        else ' ' * options.get('indent_size', 4))
        max_blanks   = options.get('max_blank_lines', 2)

        # ── Pass 1: tokenise into (kind, text) segments ──────────────────
        # kind = 'code' | 'string' | 'comment'
        LONG_STR = re.compile(r'\[(=*)\[')
        segments = []
        i, n = 0, len(code)

        while i < n:
            m = LONG_STR.match(code, i)
            if m:
                level   = len(m.group(1))
                close   = ']' + '=' * level + ']'
                end_idx = code.find(close, m.end())
                if end_idx != -1:
                    end_idx += len(close)
                    kind = 'comment' if (i >= 2 and code[i-2:i] == '--') else 'string'
                    segments.append((kind, code[i:end_idx]))
                    i = end_idx
                    continue
            if code[i] in ('"', "'"):
                q = code[i]; j = i + 1
                while j < n:
                    if code[j] == '\\': j += 2; continue
                    if code[j] == q:    j += 1; break
                    j += 1
                segments.append(('string', code[i:j])); i = j; continue
            if code[i:i+2] == '--':
                end_idx = code.find('\n', i)
                if end_idx == -1: end_idx = n
                segments.append(('comment', code[i:end_idx])); i = end_idx; continue
            j = i
            while j < n:
                m2 = LONG_STR.match(code, j)
                if m2: break
                if code[j:j+2] == '--' or code[j] in ('"', "'"): break
                if code[j] == '\n': j += 1; break
                j += 1
            segments.append(('code', code[i:j])); i = j

        # ── Pass 2: operator / comma spacing (code segments only) ────────
        def fmt_code(s):
            if options.get('space_operators', True):
                s = re.sub(r'\s*==\s*',   ' == ', s)
                s = re.sub(r'\s*~=\s*',   ' ~= ', s)
                s = re.sub(r'\s*<=\s*',   ' <= ', s)
                s = re.sub(r'\s*>=\s*',   ' >= ', s)
                s = re.sub(r'\s*\.\.\s*', ' .. ', s)
            if options.get('space_after_comma', True):
                s = re.sub(r',(\S)',  r', \1', s)
                s = re.sub(r'\s+,',  ',',      s)
            # collapse runs of interior spaces (outside strings)
            s = re.sub(r'(?<=\S) {2,}', ' ', s)
            return s

        rebuilt = ''.join(fmt_code(t) if k == 'code' else t for k, t in segments)

        # ── Pass 2b: strip existing leading whitespace before re-indenting
        rebuilt = '\n'.join(line.lstrip() for line in rebuilt.split('\n'))

        # ── Pass 3: line-by-line indent ───────────────────────────────────
        KW_CLOSE = re.compile(r'^\s*(end|until|else|elseif)\b')
        KW_ELSE  = re.compile(r'^\s*(else|elseif)\b')

        def count_deltas(stripped):
            bare = re.sub(r'"(?:[^"\\]|\\.)*"', '""', stripped)
            bare = re.sub(r"'(?:[^'\\]|\\.)*'", "''", bare)
            bare = re.sub(r'--.*$', '', bare)
            opens = 0
            if re.search(r'\bfunction\b', bare): opens += 1
            if re.search(r'\bif\b',       bare) and re.search(r'\bthen\b', bare): opens += 1
            if re.search(r'\belseif\b',   bare) and re.search(r'\bthen\b', bare): opens += 1
            if re.search(r'\bfor\b',      bare) and re.search(r'\bdo\b',   bare): opens += 1
            if re.search(r'\bwhile\b',    bare) and re.search(r'\bdo\b',   bare): opens += 1
            if re.match(r'^\s*do\b', stripped) and not re.search(r'\bfor\b|\bwhile\b', bare): opens += 1
            if re.match(r'^\s*repeat\b',  stripped): opens += 1
            closes = (len(re.findall(r'\bend\b', bare))
                      + len(re.findall(r'\buntil\b', bare)))
            return opens, closes

        lines     = rebuilt.split('\n')
        out       = []
        depth     = 0
        blank_run = 0
        in_ml     = False
        ml_close  = None

        for raw in lines:
            stripped = raw.strip()

            # ── optional semicolon removal ────────────────────────────────
            if options.get('semicolon_removal') and stripped == ';':
                continue

            if not stripped:
                blank_run += 1
                if blank_run <= max_blanks:
                    out.append('')
                continue
            blank_run = 0

            # multi-line string/comment passthrough
            if in_ml:
                out.append(indent_unit * depth + stripped)
                if ml_close and ml_close in stripped:
                    in_ml = False; ml_close = None
                continue

            ml_m = re.search(r'--(=*)\[\[|\[(=*)\[', stripped)
            if ml_m:
                eq    = ml_m.group(1) if ml_m.group(1) is not None else (ml_m.group(2) or '')
                close = ']' + eq + ']'
                if close not in stripped[ml_m.end():]:
                    in_ml = True; ml_close = close

            if stripped.startswith('--'):
                out.append(indent_unit * depth + stripped)
                continue

            is_close = bool(KW_CLOSE.match(stripped))
            is_else  = bool(KW_ELSE.match(stripped))

            if is_close:
                depth = max(0, depth - 1)

            # ── optional blank line before 'end' ──────────────────────────
            if options.get('newline_before_end') and re.match(r'^end\b', stripped):
                if out and out[-1] != '':
                    out.append('')

            line_text = indent_unit * depth + stripped
            if options.get('trailing_whitespace', True):
                line_text = line_text.rstrip()
            out.append(line_text)

            if is_else:
                depth += 1
            else:
                o, c = count_deltas(stripped)
                if is_close:
                    c -= 1
                depth = max(0, depth + o - c)

        result = '\n'.join(out)

        # ── Pass 4: collapse excess blank lines ───────────────────────────
        if max_blanks >= 0:
            pattern = r'\n{' + str(max_blanks + 2) + r',}'
            result = re.sub(pattern, '\n' * (max_blanks + 1), result)

        # ── Pass 5: optional – align consecutive 'local x = ...' blocks ──
        if options.get('align_assignments'):
            result = self._align_local_assignments(result)

        # ── Pass 6: normalise minimum indent to zero ──────────────────────
        if options.get('normalize_min_indent', True):
            out_lines = result.split('\n')
            indents = [
                len(l) - len(l.lstrip())
                for l in out_lines
                if l.strip() and not l.lstrip().startswith('--')
            ]
            if indents:
                shift = min(indents)
                if shift > 0:
                    out_lines = [
                        l[shift:] if len(l) >= shift and l[:shift] == l[:shift][0] * shift
                        else l
                        for l in out_lines
                    ]
                    result = '\n'.join(out_lines)

        return result

    @staticmethod
    def _align_local_assignments(code: str) -> str:
        """
        Align the '=' sign in runs of consecutive 'local x = ...' lines.
        Lines that are blank or non-local break a run.
        """
        import re
        LOCAL_RE = re.compile(r'^(\s*local\s+\w[\w\d_]*)\s*=\s*(.+)$')
        lines = code.split('\n')
        out   = []
        i     = 0

        while i < len(lines):
            m = LOCAL_RE.match(lines[i])
            if not m:
                out.append(lines[i])
                i += 1
                continue

            # collect the run
            run_start = i
            run = []
            while i < len(lines):
                lm = LOCAL_RE.match(lines[i])
                if lm:
                    run.append((lines[i], lm.group(1), lm.group(2)))
                    i += 1
                elif lines[i].strip() == '':
                    break
                else:
                    break

            if len(run) == 1:
                out.append(run[0][0])
            else:
                max_lhs = max(len(r[1]) for r in run)
                for orig, lhs, rhs in run:
                    out.append(lhs.ljust(max_lhs) + ' = ' + rhs)
            # consume any blank lines that ended the run
            while i < len(lines) and lines[i].strip() == '':
                out.append(lines[i])
                i += 1

        return '\n'.join(out)

    @staticmethod
    def _shape_format_code(code: str, options: dict) -> str:
        """
        Reflow code tokens so the block of text forms a shape silhouette.

        Strategy:
          1. Tokenise code into a flat list of space-separated chunks,
             stripping all original whitespace/newlines.
          2. Load the shape bitmap and scale it to `shape_width` columns.
          3. For each row of the bitmap, compute how many printable chars
             are available (number of '#' cells).  Pack tokens left-to-right
             until we'd overflow, then stop — pad the rest with spaces.
          4. Any tokens still remaining after the shape is exhausted get
             appended as normal lines at the bottom (so no code is lost).
        """
        import re

        shape_name  = options.get("shape_name", "Among Us")
        target_w    = max(40, options.get("shape_width", 120))
        custom_text = options.get("shape_custom", "")

        # ── 1. Get silhouette rows ────────────────────────────────────────
        if shape_name == "Custom":
            raw_rows = [l for l in custom_text.split('\n') if l.strip()]
        else:
            raw_rows = list(FormatOptionsDialog.SHAPES.get(shape_name, []))

        if not raw_rows:
            return code  # nothing to do

        # ── 2. Scale rows to target_w ────────────────────────────────────
        # Normalise each row to exactly target_w chars by stretching/trimming.
        # We treat any non-space char as a filled cell.
        def scale_row(row, target):
            src_w = max(len(row), 1)
            result = []
            for col in range(target):
                src_col = int(col * src_w / target)
                ch = row[src_col] if src_col < len(row) else ' '
                result.append('#' if ch != ' ' else ' ')
            return ''.join(result)

        rows = [scale_row(r, target_w) for r in raw_rows]

        # ── 3. Tokenise: strip all whitespace, split on token boundaries ──
        # We want to preserve Lua tokens (strings, comments, identifiers,
        # operators, numbers) as atomic units — never break inside one.
        TOKEN_RE = re.compile(
            r'"(?:[^"\\]|\\.)*"'      # double-quoted string
            r"|'(?:[^'\\]|\\.)*'"     # single-quoted string
            r"|--\[\[.*?\]\]"         # long comment
            r"|--[^\n]*"              # single-line comment
            r"|\[\[.*?\]\]"           # long string
            r"|[a-zA-Z_]\w*"          # identifier / keyword
            r"|0[xX][0-9a-fA-F]+"    # hex number
            r"|\d+\.?\d*(?:[eE][+-]?\d+)?"  # number
            r"|[~<>=!]=|\.\.\.|\.\."  # multi-char operators
            r"|[^\s]",                # any other single char
            re.DOTALL
        )
        tokens = TOKEN_RE.findall(code)
        if not tokens:
            return code

        tok_idx = 0
        out_lines = []

        # ── 4. Pack tokens row by row ─────────────────────────────────────
        for row in rows:
            # Count filled cells — that's our budget in characters
            filled_cols = [c for c, ch in enumerate(row) if ch == '#']
            if not filled_cols:
                out_lines.append('')
                continue

            budget = len(filled_cols)     # available printable chars
            left   = filled_cols[0]       # left-margin (spaces before content)

            # Gather tokens that fit within budget
            line_tokens = []
            used = 0
            while tok_idx < len(tokens):
                tok = tokens[tok_idx]
                need = len(tok) + (1 if line_tokens else 0)  # space separator
                if used + need > budget:
                    break
                if line_tokens:
                    used += 1   # space
                line_tokens.append(tok)
                used += len(tok)
                tok_idx += 1

            if not line_tokens:
                # No tokens fit — output a blank indented line
                out_lines.append(' ' * left)
                continue

            # Pad the token run to exactly `budget` chars with trailing spaces
            content = ' '.join(line_tokens)
            content = content.ljust(budget)

            out_lines.append(' ' * left + content)

        # ── 5. Append any remaining tokens below the shape ────────────────
        if tok_idx < len(tokens):
            remaining = ' '.join(tokens[tok_idx:])
            # Wrap at target_w
            while remaining:
                chunk = remaining[:target_w]
                remaining = remaining[target_w:]
                out_lines.append(chunk)

        return '\n'.join(out_lines)

    def clear_recent_files(self):
        """Clear the recent files list."""
        reply = QMessageBox.question(
            self, "Clear Recent Files",
            "Are you sure you want to clear the recent files list?",
            QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No
        )
        if reply == QMessageBox.StandardButton.Yes:
            self.recent_files = []
            self.save_recent_files()


    
    # ── Terminal ───────────────────────────────────────────────────────────────

    def eventFilter(self, obj, event):
        from PyQt6.QtCore import QEvent
        if obj is self._term_input and event.type() == QEvent.Type.KeyPress:
            key = event.key()
            if key == Qt.Key.Key_Up:
                if self._term_history and self._term_hist_idx > 0:
                    self._term_hist_idx -= 1
                    self._term_input.setText(self._term_history[self._term_hist_idx])
                return True
            if key == Qt.Key.Key_Down:
                self._term_hist_idx = min(self._term_hist_idx + 1, len(self._term_history))
                if self._term_hist_idx < len(self._term_history):
                    self._term_input.setText(self._term_history[self._term_hist_idx])
                else:
                    self._term_input.clear()
                return True
        return super().eventFilter(obj, event)

    def _term_write(self, text, colour=None):
        if colour:
            escaped = text.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;').replace(' ','&nbsp;').replace(chr(10),'<br>')
            self._term_output.appendHtml(f'<span style="color:{colour};">{escaped}</span>')
        else:
            self._term_output.appendPlainText(text.rstrip())
        sb = self._term_output.verticalScrollBar()
        sb.setValue(sb.maximum())

    def _term_run(self):
        cmd = self._term_input.text().strip()
        if not cmd:
            return
        if not self._term_history or self._term_history[-1] != cmd:
            self._term_history.append(cmd)
        self._term_hist_idx = len(self._term_history)
        self._term_input.clear()
        cwd = os.getcwd()
        self._term_write(f"{cwd} $ {cmd}", colour="#6cb6ff")
        parts = cmd.split(None, 1)
        if parts[0] == "cd":
            target = os.path.expandvars(os.path.expanduser(parts[1].strip() if len(parts) > 1 else "~"))
            try:
                os.chdir(target)
                self._term_cwd_label.setText(os.getcwd())
            except Exception as e:
                self._term_write(str(e), colour="#f97583")
            return
        if parts[0] in ("clear", "cls"):
            self._term_clear(); return
        self._term_kill()
        self._term_process = QProcess(self)
        self._term_process.setWorkingDirectory(os.getcwd())
        self._term_process.setProcessEnvironment(QProcessEnvironment.systemEnvironment())
        self._term_process.readyReadStandardOutput.connect(self._term_on_stdout)
        self._term_process.readyReadStandardError.connect(self._term_on_stderr)
        self._term_process.finished.connect(self._term_on_finished)
        if sys.platform == "win32":
            self._term_process.start("cmd.exe", ["/c", cmd])
        else:
            self._term_process.start("/bin/sh", ["-c", cmd])

    def _term_on_stdout(self):
        self._term_write(bytes(self._term_process.readAllStandardOutput()).decode("utf-8","replace"))

    def _term_on_stderr(self):
        self._term_write(bytes(self._term_process.readAllStandardError()).decode("utf-8","replace"), colour="#f97583")

    def _term_on_finished(self, code, _):
        self._term_write(f"[exited {code}]", colour="#888")
        self._term_process = None

    def _term_kill(self):
        if self._term_process and self._term_process.state() != QProcess.ProcessState.NotRunning:
            self._term_process.kill()
            self._term_process.waitForFinished(500)
            self._term_process = None

    def _term_clear(self):
        self._term_output.clear()

    # ── DLL Bridge ─────────────────────────────────────────────────────────────

    def _bridge_set_status(self, ok: bool):
        if ok:
            self._lbl_bridge_status.setStyleSheet("color:#3fb950;font-size:10pt;")
            self._lbl_bridge_status.setToolTip("Bridge: connected")
        else:
            self._lbl_bridge_status.setStyleSheet("color:#f85149;font-size:10pt;")
            self._lbl_bridge_status.setToolTip("Bridge: not connected")

    def _bridge_send(self, script: str) -> bool:
        """
        4-byte LE uint32 length prefix + UTF-8 payload.
        DLL side: ReadFile/recv the 4-byte header, then read that many bytes.
        """
        payload = script.encode("utf-8")
        data    = struct.pack("<I", len(payload)) + payload
        try:
            if sys.platform == "win32":
                import ctypes, ctypes.wintypes as wt
                h = ctypes.windll.kernel32.CreateFileW(
                    self._bridge_pipe, 0x40000000, 0, None, 3, 0, None)
                if h == wt.HANDLE(-1).value:
                    return False
                written = wt.DWORD(0)
                ctypes.windll.kernel32.WriteFile(h, data, len(data), ctypes.byref(written), None)
                ctypes.windll.kernel32.CloseHandle(h)
                return written.value == len(data)
            else:
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
                    s.settimeout(2.0)
                    s.connect(self._bridge_pipe)
                    s.sendall(data)
                return True
        except Exception:
            return False

    def _bridge_push(self, silent=False):
        editor = self.get_current_editor()
        if not editor:
            if not silent: QMessageBox.warning(self, "Bridge", "No active editor.")
            return
        script = editor.get_text().strip()
        if not script:
            if not silent: QMessageBox.warning(self, "Bridge", "Editor is empty.")
            return
        ok = self._bridge_send(script)
        self._bridge_set_status(ok)
        if not silent:
            if ok:
                self.statusBar().showMessage("Script pushed to executor.", 2000)
            else:
                QMessageBox.warning(self, "Bridge",
                    f"Could not connect to:\n{self._bridge_pipe}\n\n"
                    "Make sure your executor DLL is listening on the pipe.")

    def _bridge_push_file(self, path: str):
        try:
            with open(path, "r", encoding="utf-8") as f:
                script = f.read()
        except Exception as e:
            self.statusBar().showMessage(f"[Bridge] Read error: {e}", 3000); return
        ok = self._bridge_send(script)
        self._bridge_set_status(ok)
        self.statusBar().showMessage(
            f"[Bridge] Auto-pushed {os.path.basename(path)}" + ("" if ok else " -- pipe not connected"), 2500)

    def _bridge_ext_changed(self, path: str):
        if path not in self._bridge_watcher.files():
            self._bridge_watcher.addPath(path)
        self._bridge_push_file(path)

    def _bridge_show_settings(self):
        dlg = _BridgeSettingsDialog(self,
            pipe=self._bridge_pipe,
            auto_push=self._bridge_auto_push,
            ext_path=self._bridge_ext_path)
        if not dlg.exec():
            return
        cfg = dlg.get_config()
        self._bridge_pipe      = cfg["pipe"]
        self._bridge_auto_push = cfg["auto_push"]
        if self._bridge_watcher.files():
            self._bridge_watcher.removePaths(self._bridge_watcher.files())
        self._bridge_ext_path = cfg["ext_path"]
        if self._bridge_ext_path and os.path.isfile(self._bridge_ext_path):
            self._bridge_watcher.addPath(self._bridge_ext_path)
            self.statusBar().showMessage(f"[Bridge] Watching {self._bridge_ext_path}", 2500)
        ok = self._bridge_send("")
        self._bridge_set_status(ok)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ide = LuaIDE()
    ide.show()
    sys.exit(app.exec())

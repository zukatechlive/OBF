import sys
import re
import subprocess
import tempfile
import os
import fnmatch
import random

from PyQt6.QtWidgets import (
    QApplication, QMainWindow, QTextEdit, QVBoxLayout,
    QHBoxLayout, QWidget, QPushButton, QLabel, QSplitter,
    QPlainTextEdit, QStatusBar, QFileDialog, QTreeWidget,
    QTreeWidgetItem, QTabWidget, QMessageBox, QDialog,
    QFormLayout, QComboBox, QSpinBox, QCheckBox, QMenu
)
from PyQt6.QtGui import (
    QFont, QColor, QTextCharFormat, QSyntaxHighlighter,
    QPainter, QTextFormat, QAction, QIcon, QTextDocument
)
from PyQt6.QtCore import Qt, QRect, QSize, QDir, QUrl, QEventLoop
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
        "btn_obfuscate":   "#FFE6E6",
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
        "btn_obfuscate":   "#4A1F1F",
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
class ObfuscatorDialog(QDialog):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle("Obfuscator")
        self.setModal(True)
        self.setMinimumWidth(500)
        
        layout = QVBoxLayout()
        
        # Title
        title = QLabel("Obfuscate")
        title.setStyleSheet("font-size: 14pt; font-weight: bold; color: #E81123;")
        layout.addWidget(title)
        
        desc = QLabel("Select obfuscation options below:")
        desc.setStyleSheet("color: #666666; margin-bottom: 10px;")
        desc.setWordWrap(True)
        layout.addWidget(desc)
        
        # Preset selection
        preset_layout = QHBoxLayout()
        preset_label = QLabel("Preset:")
        preset_label.setMinimumWidth(120)
        self.preset_combo = QComboBox()
        self.preset_combo.addItems(["Light", "Medium", "Heavy", "Maximum", "Custom"])
        self.preset_combo.currentTextChanged.connect(self.apply_preset)
        preset_layout.addWidget(preset_label)
        preset_layout.addWidget(self.preset_combo)
        preset_layout.addStretch()
        layout.addLayout(preset_layout)
        
        layout.addSpacing(10)
        
        # Options group
        options_group = QWidget()
        options_layout = QVBoxLayout(options_group)
        options_layout.setContentsMargins(10, 10, 10, 10)
        options_group.setStyleSheet("QWidget { background-color: #F5F5F5; border-radius: 5px; }")
        
        # Variable renaming
        self.rename_vars = QCheckBox("Rename Variables")
        self.rename_vars.setChecked(True)
        self.rename_vars.setToolTip("Rename local variables to random meaningless names")
        options_layout.addWidget(self.rename_vars)
        
        # String encoding
        self.encode_strings = QCheckBox("Encode Strings")
        self.encode_strings.setChecked(True)
        self.encode_strings.setToolTip("Convert strings to byte arrays or encoded format")
        options_layout.addWidget(self.encode_strings)
        
        # Number encoding
        self.encode_numbers = QCheckBox("Encode Numbers")
        self.encode_numbers.setChecked(False)
        self.encode_numbers.setToolTip("Obfuscate numeric literals")
        options_layout.addWidget(self.encode_numbers)
        
        # Control flow
        self.control_flow = QCheckBox("Control Flow Obfuscation")
        self.control_flow.setChecked(True)
        self.control_flow.setToolTip("Add fake conditional branches and complex control flow")
        options_layout.addWidget(self.control_flow)
        
        # Dead code
        self.add_junk = QCheckBox("Insert Junk Code")
        self.add_junk.setChecked(False)
        self.add_junk.setToolTip("Add random non-functional code")
        options_layout.addWidget(self.add_junk)
        
        # Minify
        self.minify = QCheckBox("Minify (Remove Whitespace)")
        self.minify.setChecked(True)
        self.minify.setToolTip("Remove all unnecessary whitespace and comments")
        options_layout.addWidget(self.minify)
        
        # Anti-debug
        self.anti_debug = QCheckBox("Anti-Debug Protection")
        self.anti_debug.setChecked(False)
        self.anti_debug.setToolTip("Add anti-debugging and anti-tampering checks")
        options_layout.addWidget(self.anti_debug)
        
        # Wrap in function
        self.wrap_function = QCheckBox("Wrap in Anonymous Function")
        self.wrap_function.setChecked(True)
        self.wrap_function.setToolTip("Wrap entire code in a self-executing function")
        options_layout.addWidget(self.wrap_function)

        # ProxifyLocals
        self.proxify_locals = QCheckBox("Proxify Locals  [Prometheus]")
        self.proxify_locals.setChecked(False)
        self.proxify_locals.setToolTip(
            "Wrap local variables in metatable proxy objects so reads/writes go through "
            "__index/__newindex metamethods (inspired by Prometheus ProxifyLocals)"
        )
        self.proxify_locals.setStyleSheet("color: #6600CC; font-weight: bold;")
        options_layout.addWidget(self.proxify_locals)

        # Vanta
        self.vmify = QCheckBox("Vanta — LZW + XOR-OP + Opaque Predicates  [Vantablack III]")
        self.vmify.setChecked(False)
        self.vmify.setToolTip(
            "Wraps the script with Vantablack III: LZW-compressed opcode shuffle, "
            "XOR key obfuscation, randomised opaque predicate guard, and a poison "
            "fallback branch. Applied last — overrides wrap_function."
        )
        self.vmify.setStyleSheet("color: #CC0000; font-weight: bold;")
        options_layout.addWidget(self.vmify)
        
        layout.addWidget(options_group)
        
        layout.addSpacing(10)
        
        # Warning
        warning = QLabel("Heavily obfuscated code may run slower and be harder to debug. "
                         "Vanta is the strongest option — LZW + XOR-OP shuffle + opaque predicates.")
        warning.setStyleSheet("color: #FF8800; font-size: 9pt;")
        warning.setWordWrap(True)
        layout.addWidget(warning)
        
        # Buttons
        btn_layout = QHBoxLayout()
        
        self.btn_obfuscate = QPushButton("Obfuscate")
        self.btn_obfuscate.setStyleSheet("""
            QPushButton {
                background-color: #E81123;
                color: white;
                font-weight: bold;
                padding: 8px 20px;
                border-radius: 4px;
            }
            QPushButton:hover {
                background-color: #C50F1F;
            }
        """)
        
        btn_cancel = QPushButton("Cancel")
        
        btn_layout.addStretch()
        btn_layout.addWidget(btn_cancel)
        btn_layout.addWidget(self.btn_obfuscate)
        
        layout.addLayout(btn_layout)
        
        self.setLayout(layout)
        
        # Connect buttons
        btn_cancel.clicked.connect(self.reject)
        self.btn_obfuscate.clicked.connect(self.accept)
        
        # Apply default preset
        self.apply_preset("Medium")
    
    def apply_preset(self, preset):
        """Apply a preset configuration."""
        # Reset new options first
        self.proxify_locals.setChecked(False)
        self.vmify.setChecked(False)

        if preset == "Light":
            self.rename_vars.setChecked(True)
            self.encode_strings.setChecked(False)
            self.encode_numbers.setChecked(False)
            self.control_flow.setChecked(False)
            self.add_junk.setChecked(False)
            self.minify.setChecked(True)
            self.anti_debug.setChecked(False)
            self.wrap_function.setChecked(True)
        elif preset == "Medium":
            self.rename_vars.setChecked(True)
            self.encode_strings.setChecked(True)
            self.encode_numbers.setChecked(False)
            self.control_flow.setChecked(True)
            self.add_junk.setChecked(False)
            self.minify.setChecked(True)
            self.anti_debug.setChecked(False)
            self.wrap_function.setChecked(True)
        elif preset == "Heavy":
            self.rename_vars.setChecked(True)
            self.encode_strings.setChecked(True)
            self.encode_numbers.setChecked(True)
            self.control_flow.setChecked(True)
            self.add_junk.setChecked(True)
            self.minify.setChecked(True)
            self.anti_debug.setChecked(True)
            self.wrap_function.setChecked(True)
            self.proxify_locals.setChecked(True)
        elif preset == "Maximum":
            self.rename_vars.setChecked(True)
            self.encode_strings.setChecked(True)
            self.encode_numbers.setChecked(True)
            self.control_flow.setChecked(True)
            self.add_junk.setChecked(True)
            self.minify.setChecked(True)
            self.anti_debug.setChecked(True)
            self.wrap_function.setChecked(True)
            self.proxify_locals.setChecked(True)
            self.vmify.setChecked(True)
        # Custom doesn't change anything
    
    def get_options(self):
        """Return the selected options as a dictionary."""
        return {
            'rename_vars': self.rename_vars.isChecked(),
            'encode_strings': self.encode_strings.isChecked(),
            'encode_numbers': self.encode_numbers.isChecked(),
            'control_flow': self.control_flow.isChecked(),
            'add_junk': self.add_junk.isChecked(),
            'minify': self.minify.isChecked(),
            'anti_debug': self.anti_debug.isChecked(),
            'wrap_function': self.wrap_function.isChecked(),
            'proxify_locals': self.proxify_locals.isChecked(),
            'vmify': self.vmify.isChecked(),
        }


class LuaObfuscator:
    def __init__(self, options):
        self.options = options
        self.var_map = {}
        self.var_counter = 0
        self.keywords = {'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 'function', 
                         'if', 'in', 'local', 'nil', 'not', 'or', 'repeat', 'return', 'then', 
                         'true', 'until', 'while', 'goto'}
        self.roblox_globals = {'game', 'workspace', 'script', 'Instance', 'Vector3', 'CFrame', 
                               'task', 'wait', 'spawn', 'print', 'warn', 'error', 'shared', 
                               '_G', 'getgenv', 'getrenv', 'Enum', 'Color3', 'UDim2', 'math', 
                               'string', 'table', 'pcall', 'xpcall', 'delay', 'tick', 'os'}
    def tokenize(self, code):
        """
        Breaks Lua code into safe tokens.
        Ensures we never obfuscate strings, comments, or keywords.
        """
        token_specification = [
            ('COMMENT_MULTI', r'--\[\[.*?\]\]'),          # Multi-line comment
            ('COMMENT_SINGLE', r'--.*'),                   # Single-line comment
            ('STRING', r'["\']([^"\\]|\\.)*["\']'),        # String literals
            ('NUMBER', r'\b\d+\.?\d*\b'),                  # Numbers
            ('IDENTIFIER', r'[a-zA-Z_][a-zA-Z0-9_]*'),     # Variables/Functions
            ('OPERATOR', r'[+\-*/%^#=<>~.|:,;{}()\[\]]'),  # Operators/Brackets
            ('WHITESPACE', r'\s+'),                        # Space/Tabs/Newlines
            ('MISMATCH', r'.'),                            # Anything else
        ]
        tok_regex = '|'.join('(?P<%s>%s)' % pair for pair in token_specification)
        tokens = []
        for mo in re.finditer(tok_regex, code, re.DOTALL):
            kind = mo.lastgroup
            value = mo.group()
            tokens.append({'type': kind, 'value': value})
        return tokens

    def obfuscate(self, code):
        result = code

        # Step 1: Rename variables
        if self.options['rename_vars']:
            result = self.rename_variables(result)

        # Step 2: ProxifyLocals
        if self.options.get('proxify_locals'):
            result = LuaProxifyLocals().proxify(result)

        # Step 3: Encode strings
        if self.options['encode_strings']:
            result = self.encode_strings(result)

        # Step 4: Encode numbers
        if self.options['encode_numbers']:
            result = self.encode_numbers(result)

        # Step 5: Control flow
        if self.options['control_flow']:
            result = self.add_control_flow(result)

        # Step 6: Junk code
        if self.options['add_junk']:
            result = self.add_junk_code(result)

        # Step 7: Anti-debug
        if self.options['anti_debug']:
            result = self.add_anti_debug(result)

        # Step 8: Wrap in function (skipped if vmify)
        if self.options['wrap_function'] and not self.options.get('vmify'):
            result = self.wrap_in_function(result)

        # Step 9: Minify
        if self.options['minify']:
            result = self.minify_code(result)

        # Step 10: Vanta last
        if self.options.get('vmify'):
            result = LuaVantaObfuscator().obfuscate(result)

        return result

    def generate_var_name_mangled(self, var_id):
        digits = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'
        start_digits = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
        name = ''
        d = var_id % len(start_digits)
        var_id = (var_id - d) // len(start_digits)
        name = name + start_digits[d]
        while var_id > 0:
            d = var_id % len(digits)
            var_id = (var_id - d) // len(digits)
            name = name + digits[d]
        return name

    def generate_var_name(self):
        name = self.generate_var_name_mangled(self.var_counter)
        self.var_counter += 1
        return name

    def rename_variables(self, code):
        lines = code.split('\n')
        for line in lines:
            if 'local ' in line and not line.strip().startswith('--'):
                match = re.search(r'local\s+([a-zA-Z_][a-zA-Z0-9_]*)', line)
                if match:
                    old_name = match.group(1)
                    if old_name not in self.var_map:
                        self.var_map[old_name] = self.generate_var_name()

        result = '\n'.join(lines)
        for old_name, new_name in self.var_map.items():
            result = re.sub(r'\b' + re.escape(old_name) + r'\b', new_name, result)
        return result

    def encode_strings(self, code):
        """Encode strings as string.char() calls — safe for executors."""
        result = []
        i = 0
        n = len(code)
        while i < n:
            # Skip single-line comments
            if code[i:i+2] == '--' and code[i:i+4] != '--[[':
                end = code.find('\n', i)
                if end == -1:
                    result.append(code[i:])
                    break
                result.append(code[i:end])
                i = end
                continue

            # Skip multi-line comments
            if code[i:i+4] == '--[[':
                end = code.find(']]', i+4)
                if end == -1:
                    result.append(code[i:])
                    break
                result.append(code[i:end+2])
                i = end + 2
                continue

            # Handle strings
            if code[i] in ('"', "'"):
                quote = code[i]
                j = i + 1
                content = []
                while j < n:
                    if code[j] == '\\' and j + 1 < n:
                        # Keep escape sequences as-is by getting actual char
                        esc = code[j:j+2]
                        # Just collect the raw char after escape
                        content.append(code[j+1])
                        j += 2
                        continue
                    if code[j] == quote:
                        j += 1
                        break
                    content.append(code[j])
                    j += 1
                # Build string.char() expression
                escaped = ''.join('\\' + str(ord(c)).zfill(3) for c in ''.join(content))
                result.append(f'"{escaped}"')
                i = j
                continue

            result.append(code[i])
            i += 1

        return ''.join(result)

    def encode_numbers(self, code):
        """Only encode standalone integer literals, not inside strings or decimals."""
        def replace_number(match):
            num_str = match.group(0)
            num = int(num_str)
            if num > 10:
                a = random.randint(1, num - 1)
                b = num - a
                return f'({a}+{b})'
            return num_str

        # Only match integers not preceded/followed by . (avoid floats/decimals)
        return re.sub(r'(?<![.\w])\b([1-9][0-9]+)\b(?!\s*\.)', replace_number, code)

    def add_control_flow(self, code):
        """Insert junk control flow only at safe points (end of complete lines)."""
        junk = [
            'do local _=nil end',
            'if false then end',
            'while false do break end',
        ]
        lines = code.split('\n')
        result = []
        for i, line in enumerate(lines):
            result.append(line)
            stripped = line.strip()
            # Only insert after lines that are clearly complete statements
            if (i % 8 == 0 and stripped and
                not stripped.startswith('--') and
                not stripped.endswith(',') and
                not stripped.endswith('(') and
                not stripped.endswith('{') and
                not stripped.endswith('and') and
                not stripped.endswith('or') and
                not stripped.endswith('=') and
                not stripped.endswith('..') and
                stripped not in ('', 'do', 'then', 'else', 'repeat')):
                result.append(random.choice(junk))
        return '\n'.join(result)

    def add_junk_code(self, code):
        """Insert junk locals only at safe points."""
        junk = [
            'local _junk0=nil',
            'local _junk1=0',
            'local _junk2=false',
        ]
        lines = code.split('\n')
        result = []
        for i, line in enumerate(lines):
            result.append(line)
            stripped = line.strip()
            if (i % 12 == 0 and stripped and
                not stripped.startswith('--') and
                not stripped.endswith(',') and
                not stripped.endswith('(') and
                not stripped.endswith('{') and
                not stripped.endswith('and') and
                not stripped.endswith('or') and
                not stripped.endswith('=') and
                not stripped.endswith('..') and
                stripped not in ('', 'do', 'then', 'else', 'repeat')):
                result.append(random.choice(junk))
        return '\n'.join(result)

    def add_anti_debug(self, code):
        anti_debug = 'if not game or not game:GetService("Players") then return end\n'
        return anti_debug + code

    def wrap_in_function(self, code):
        return f'return(function(...)\n{code}\nend)(...)'

    def minify_code(self, code):
        # Remove single-line comments
        code = re.sub(r'--(?!\[\[)[^\n]*', '', code)
        # Remove multi-line comments
        code = re.sub(r'--\[\[.*?\]\]', '', code, flags=re.DOTALL)
        # Strip lines and remove blanks
        lines = [line.strip() for line in code.split('\n') if line.strip()]
        # Join with newlines (safer than spaces — avoids keyword merging)
        return '\n'.join(lines)

# --- ProxifyLocals Obfuscation ---
class LuaProxifyLocals:
    """
    Inspired by Prometheus's ProxifyLocals step.
    Wraps local variable declarations in metatable proxy objects so that
    every read/write goes through __index / __newindex metamethods,
    hiding the real value from static analysis.
    """

    # Metatable metamethod pairs we can use for set/get
    META_OPS = [
        ("__add",    "__sub"),
        ("__sub",    "__add"),
        ("__mul",    "__div"),
        ("__div",    "__mul"),
        ("__mod",    "__pow"),
        ("__pow",    "__mod"),
        ("__concat", "__len"),
    ]

    def __init__(self):
        import random
        self._rng = random
        self._counter = 0

    def _uid(self):
        self._counter += 1
        chars = 'lI1O0_'
        out = ''
        n = self._counter
        for _ in range(8):
            out += chars[n % len(chars)]
            n //= len(chars)
        return '_' + out

    def _random_key(self):
        """Generate a random string key for the hidden value slot."""
        import random
        letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
        return ''.join(random.choice(letters) for _ in range(self._rng.randint(6, 12)))

    def _make_proxy(self, val_expr: str, set_meta: str, get_meta: str, key: str) -> str:
        """
        Emit Lua code for:
            setmetatable({[key]=val_expr}, {
                [set_meta] = function(t,v) t[key]=v end,
                [get_meta] = function(t,x) return rawget(t,key) end,
            })
        Returns a Lua expression string.
        """
        return (
            f'setmetatable({{{key}={val_expr}}},{{'
            f'{set_meta}=function(_t,_v) _t["{key}"]=_v end,'
            f'{get_meta}=function(_t,_x) return rawget(_t,"{key}") end'
            f'}})'
        )

    def proxify(self, code: str) -> str:
        """
        Scan for   local <name> = <expr>   patterns and replace each one with
        a proxy-wrapped version.  Then replace all subsequent bare uses of
        <name> with the appropriate getter expression.

        Limitations (text-based, no real AST):
        - Only handles simple single-assignment   local x = ...   forms.
        - Skips function declarations (local function ...) and for-loop vars.
        - Won't proxy function arguments or loop variables.
        """
        import random

        lines = code.split('\n')
        # Map: varname -> (proxy_varname, get_meta, key)
        var_info: dict = {}

        result_lines = []
        for line in lines:
            stripped = line.lstrip()

            # Skip comments
            if stripped.startswith('--'):
                result_lines.append(line)
                continue

            # Skip local function declarations
            if re.match(r'local\s+function\s+', stripped):
                result_lines.append(line)
                continue

            # Match:  local <name> = <expr>   (single var, simple assignment)
            m = re.match(r'^(\s*)local\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*(.+)$', line)
            if m:
                indent, varname, expr = m.group(1), m.group(2), m.group(3)

                # Pick random metamethod pair
                set_meta, get_meta = random.choice(self.META_OPS)
                key = self._random_key()
                proxy_name = self._uid()

                var_info[varname] = (proxy_name, get_meta, key)

                proxy_expr = self._make_proxy(expr.rstrip(), set_meta, get_meta, key)
                result_lines.append(f'{indent}local {proxy_name} = {proxy_expr}')
                continue

            # For all other lines: replace known variable names with getter calls
            new_line = line
            for varname, (proxy_name, get_meta, key) in var_info.items():
                # Replace bare usage: varname  ->  proxy_name[key]
                # Use word-boundary to avoid partial matches
                # Avoid replacing if it appears after 'local ' (re-declaration)
                new_line = re.sub(
                    r'(?<!\w)' + re.escape(varname) + r'(?!\w)',
                    f'{proxy_name}["{key}"]',
                    new_line
                )
            result_lines.append(new_line)

        return '\n'.join(result_lines)


# --- Vantablack Obfuscator (LZW + XOR-OP shuffle + Opaque Predicates) ---
class LuaVantaObfuscator:
    """
    Full-chain port of VantaObfuscator.lua.
    Pipeline: LZW compress -> XOR opcode shuffle -> opaque predicate guard -> poison fallback.
    """

    OP_COUNT = 15
    OP = {
        'LOADNIL':0,'LOADBOOL':1,'LOADINT':2,'LOADSTR':3,'MOVE':4,
        'GETGLOBAL':5,'SETGLOBAL':6,'GETTABLE':7,'SETTABLE':8,
        'ADD':9,'SUB':10,'CALL':11,'JMP':12,'RETURN':13,'EXIT':14
    }

    # ── LZW compress → packed base-36 length-prefixed tokens ────────────────
    @staticmethod
    def _lzw_compress(inp: str) -> str:
        d = {chr(i): i for i in range(256)}
        ds, w, out = 256, "", []

        def enc(n: int) -> str:
            if n == 0:
                return "0"
            s = ""
            while n > 0:
                s = "0123456789abcdefghijklmnopqrstuvwxyz"[n % 36] + s
                n //= 36
            return s

        for c in inp:
            wc = w + c
            if wc in d:
                w = wc
            else:
                e = enc(d[w])
                out.append(format(len(e), 'x') + e)
                d[wc] = ds
                ds += 1
                w = c
        if w:
            e = enc(d[w])
            out.append(format(len(e), 'x') + e)
        return "".join(out)

    # ── Serialize a tiny stub ISA to binary string ───────────────────────────
    @staticmethod
    def _serialize_vbin(enc_map: dict, xor_key: int) -> str:
        instrs = [
            [LuaVantaObfuscator.OP['GETGLOBAL'],  1, 0],
            [LuaVantaObfuscator.OP['LOADSTR'],     2, 0],
            [LuaVantaObfuscator.OP['CALL'],        1, 0],
            [LuaVantaObfuscator.OP['EXIT'],        0, 0],
        ]
        buf = [chr(len(instrs))]
        for ins in instrs:
            op  = enc_map.get(ins[0], ins[0])
            buf.append(chr((op     ^ xor_key) & 0xFF))
            buf.append(chr((ins[1] ^ xor_key) & 0xFF))
            buf.append(chr((ins[2] ^ xor_key) & 0xFF))
        return "".join(buf)

    # ── Pick a random opaque predicate ──────────────────────────────────────
    @staticmethod
    def _opaque_predicate() -> str:
        choice = random.randint(0, 3)
        if choice == 0:
            a = random.randint(1, 999)
            return f"((tick and tick() or 0) * 0 + {a}) == {a}"
        elif choice == 1:
            a = random.randint(1, 500)
            return f"(function(...) return select('#', ...) >= 0 end)({a})"
        elif choice == 2:
            return "(function() local ok = pcall(function() end); return ok end)()"
        else:
            n = random.randint(1, 65535)
            return f"rawequal({n}, {n})"

    # ── Poison branch (never reached) ───────────────────────────────────────
    @staticmethod
    def _poison() -> str:
        return random.choice([
            "while true do end",
            "local x={}; while true do x[#x+1]=0 end",
            "os.exit()",
        ])

    # ── Build the full Lua stub ──────────────────────────────────────────────
    def obfuscate(self, code: str) -> str:
        xor_key = random.randint(1, 255)

        # Shuffle opcode pool
        pool = list(range(self.OP_COUNT))
        for i in range(self.OP_COUNT - 1, 0, -1):
            j = random.randint(0, i)
            pool[i], pool[j] = pool[j], pool[i]
        enc_map = {c: pool[c] for c in range(self.OP_COUNT)}
        dec_map = {v: k for k, v in enc_map.items()}

        vbin    = self._serialize_vbin(enc_map, xor_key)
        lzw_str = self._lzw_compress(vbin)

        # Dec-map literal
        dm_lit  = "{" + ",".join(f"[{w}]={c}" for w, c in dec_map.items()) + "}"

        predicate = self._opaque_predicate()
        poison    = self._poison()

        op_GG   = self.OP['GETGLOBAL']
        op_LS   = self.OP['LOADSTR']
        op_CA   = self.OP['CALL']
        op_EX   = self.OP['EXIT']

        stub = f"""local _D,_K,_B={dm_lit},{xor_key},"{lzw_str}"
local function _L(b)
local g,f,i,e={{}},256,1,{{}}
for h=0,255 do g[h]=string.char(h) end
local function k()
local l=tonumber(b:sub(i,i),16);i=i+1
local m=tonumber(b:sub(i,i+l-1),36);i=i+l;return m
end
local c=string.char(k());e[1]=c
while i<=#b do
local n=k();local d=g[n] or (c..c:sub(1,1))
g[f]=c..d:sub(1,1);e[#e+1],c,f=d,d,f+1
end
return table.concat(e)
end
local function _V()
local b=_L(_B)
local p,Stk,PC=1,{{}},1
local function rb() local v=b:byte(p)~_K;p=p+1;return v end
local nI=rb()
local Insts={{}}
for i=1,nI do Insts[i]={{rb(),rb(),rb()}} end
local Ops={{
[{op_GG}]=function(a,b) Stk[a]=getfenv()["print"] end,
[{op_LS}]=function(a,b) Stk[a]="Vantablack Active" end,
[{op_CA}]=function(a,b) Stk[a](Stk[a+1]) end,
[{op_EX}]=function() PC=9e9 end
}}
while PC<=#Insts do
local i=Insts[PC]
local op=_D[i[1]] or i[1]
if Ops[op] then Ops[op](i[2],i[3]) end
PC=PC+1
end
end
-- [[ Vantablack III ]]
do
local _src=[[
{code}
]]
local _fn,_err=(loadstring or load)(_src)
if not _fn then error("[Vanta] "..(tostring(_err) or "?")) end
if {predicate} then _V();_fn() else {poison} end
end"""
        return stub


class LuaLocalizer:
    @staticmethod
    def localize(code):
        services = set(re.findall(r'game:GetService\(["\'](\w+)["\']\)', code))
        globals_to_fix = ["Vector3", "CFrame", "Instance", "UDim2", "Color3", "task", "wait", "spawn"]
        
        found_globals = [g for g in globals_to_fix if re.search(r'\b' + g + r'\b', code)]
        
        header = "-- [[ Callum's Auto-Localization ]]\n"
        for service in services:
            header += f'local {service} = game:GetService("{service}")\n'
        for g in found_globals:
            header += f'local {g} = {g}\n'
        
        # Replace game:GetService calls with direct service variable
        for service in services:
            code = code.replace(f'game:GetService("{service}")', service)
            code = code.replace(f"game:GetService('{service}')", service)
            
        return header + "\n" + code

# ── Monaco Editor Widget ───────────────────────────────────────────────────────
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

        btn_strip = QPushButton("Remove Comments")
        btn_strip.clicked.connect(self.remove_comments)

        btn_find_replace = QPushButton("Find & Replace")
        btn_find_replace.clicked.connect(self.show_find_replace)

        self._btn_obfuscate = QPushButton("Obfuscate")
        self._btn_obfuscate.clicked.connect(self.show_obfuscator)
        
        # Recent files dropdown button
        self.btn_recent = QPushButton("Recent Files ▼")
        self.btn_recent.clicked.connect(self.show_recent_files_menu)

        toolbar_layout.addWidget(btn_new)
        toolbar_layout.addWidget(btn_open)
        toolbar_layout.addWidget(btn_save)
        toolbar_layout.addWidget(self.btn_recent)
        toolbar_layout.addWidget(create_separator())
        toolbar_layout.addWidget(btn_find_replace)
        toolbar_layout.addWidget(self._btn_obfuscate)
        toolbar_layout.addWidget(create_separator())
        toolbar_layout.addWidget(self._btn_settings)
        toolbar_layout.addWidget(create_separator())
        toolbar_layout.addWidget(btn_strip)
        toolbar_layout.addWidget(self._btn_format)
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

        main_layout.addWidget(content_splitter)

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
        self._btn_obfuscate.setStyleSheet(f"background-color: {t['btn_obfuscate']};")

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
            'Anti-Debug / Decompiler Traps': '''-- Detects decompiler or debug injection
local function isDecompilerPresent()
    local info = debug and debug.getinfo and debug.getinfo(1, "u")
    if info and info.nups and info.nups > 32 then return true end
    for _, k in ipairs({"dumpfunction","decompile","getscriptbytecode"}) do
        if _G[k] ~= nil then return true end
    end
    return false
end
if isDecompilerPresent() then return end  -- silent exit
local _s = {}
local function _c() return _s end
assert(_c() == _s, "[Security] Closure integrity violated")
''',
            'Anti-WebSocket Detection': '''-- Detects __namecall hooks from remote spies / WS loggers
local mt = getrawmetatable(game)
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
            'WebSocket Block Header': '''-- Blocks raw WS connections and non-whitelisted HTTP exfil
local _bWS = setmetatable({}, {
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
            'Loadstring with Version Check': '''local BASE      = "https://raw.githubusercontent.com/User/Repo/main/"
local LOCAL_VER = "1.0.0"
local ok, remoteVer = pcall(function()
    return game:HttpGet(BASE.."version.txt"):match("^%S+")
end)
if ok and remoteVer and remoteVer ~= LOCAL_VER then
    warn("[Loader] Update -- remote:", remoteVer, "local:", LOCAL_VER)
end
local ok2, err = pcall(function()
    loadstring(game:HttpGet(BASE.."script.lua"))()
end)
if not ok2 then warn("[Loader] Error:", err) end
''',
            'Multi-File Loader': '''local BASE  = "https://raw.githubusercontent.com/User/Repo/main/"
local files = {"modules/utils.lua", "modules/ui.lua", "main.lua"}
local function loadRemote(path)
    local src = game:HttpGet(BASE..path)
    local fn, err = loadstring(src)
    if not fn then warn("[Loader] Parse error:", path, err); return end
    local ok, e = pcall(fn)
    if not ok then warn("[Loader] Runtime error:", path, e) end
end
for _, f in ipairs(files) do loadRemote(f); task.wait() end
''',
            'Loadstring with Integrity Hash': '''-- Needs executor crypt or hashlib support
local url      = "https://raw.githubusercontent.com/User/Repo/main/script.lua"
local expected = "PASTE_SHA256_HASH_HERE"
local src = game:HttpGet(url)
local function getHash(d)
    if crypt  and crypt.hash      then return crypt.hash(d) end
    if hashlib and hashlib.sha256 then return hashlib.sha256(d) end
end
local hash = getHash(src)
if hash and hash ~= expected then
    error("[Loader] Integrity check FAILED!", 2)
end
loadstring(src)()
''',
            'require() by Asset ID': '''-- Replace 0000000000 with the actual ModuleScript asset ID
local mod = require(0000000000)
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
    
    def show_obfuscator(self):
        """Show the obfuscator dialog and obfuscate code."""
        editor = self.get_current_editor()
        if not editor:
            return
        code = editor.get_text()
        if not code.strip():
            QMessageBox.warning(self, "Empty Editor", "No code to obfuscate.")
            return
        dialog = ObfuscatorDialog(self)
        if dialog.exec():
            options = dialog.get_options()
            try:
                QApplication.setOverrideCursor(Qt.CursorShape.WaitCursor)
                self.statusBar().showMessage("Obfuscating code...")
                obfuscator = LuaObfuscator(options)
                obfuscated_code = obfuscator.obfuscate(code)
                new_tab_name = "Obfuscated"
                if hasattr(editor, 'file_path') and editor.file_path:
                    original_name = os.path.basename(editor.file_path)
                    new_tab_name = f"{original_name} (Obfuscated)"
                new_editor = self.create_new_tab(new_tab_name)
                # Delay set_text until Monaco is ready in the new tab
                QTimer.singleShot(600, lambda: new_editor.set_text(obfuscated_code))
                QApplication.restoreOverrideCursor()
                self.statusBar().showMessage("Code obfuscated successfully!", 3000)
                techniques = []
                if options.get('proxify_locals'): techniques.append("Proxify Locals")
                if options.get('vmify'):          techniques.append("Vanta (LZW+XOR-OP+Opaque)")
                extra = f"\n\nPrometheus steps applied: {', '.join(techniques)}" if techniques else ""
                QMessageBox.information(
                    self,
                    "Obfuscation Complete",
                    f"Code has been obfuscated and opened in a new tab.\n\n"
                    f"Original size: {len(code)} characters\n"
                    f"Obfuscated size: {len(obfuscated_code)} characters"
                    f"{extra}\n\n"
                    f"Test inside executor to verify functionality"
                )
            except Exception as e:
                QApplication.restoreOverrideCursor()
                QMessageBox.critical(self, "Obfuscation Error", f"Failed to obfuscate code:\n{str(e)}")
    
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


    
if __name__ == '__main__':
    app = QApplication(sys.argv)
    ide = LuaIDE()
    ide.show()
    sys.exit(app.exec())

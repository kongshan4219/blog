---
title: "typora_plugin的混排优化跳过代码块"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-09-15# #lastmod/2024-09-15#

---

## typora_plugin 更新了，混排优化添加了正则跳过功能

修改设置文件，修改 `IGNORE_PATTERNS`

~~~
IGNORE_PATTERNS = ["<br\\s*/>","```[\s\S]*?```","~~~[\s\S]*?~~~"]
~~~

---

### ~~修改 Typora\resources\plugin\md_padding\index.js~~

替换为以下代码，混排优化时会跳过 \~\~\~代码\~\~\~ 和 \`\`\`代码\`\`\` 包裹的代码块

~~~
class mdPaddingPlugin extends BasePlugin {
    hotkey = () => [{ hotkey: this.config.HOTKEY, callback: this.call }]

    formatContent = content => {
        const { padMarkdown } = require("./md-padding.min");
        
        // Split content into code blocks and non-code blocks
        // This regex matches both ``` and ~~~ delimited code blocks
        const codeBlockRegex = /(```[\s\S]*?```|~~~[\s\S]*?~~~)/;
        const parts = content.split(codeBlockRegex);
        
        // Format non-code blocks and preserve code blocks
        const formattedParts = parts.map((part, index) => {
            if (index % 2 === 0) {
                // Non-code block: apply formatting
                return padMarkdown(part, { 
                    ignoreWords: this.config.IGNORE_WORDS, 
                    ignorePatterns: this.config.IGNORE_PATTERNS 
                });
            } else {
                // Code block: preserve as-is
                return part;
            }
        });
        
        // Join the parts back together
        return formattedParts.join('');
    }

    removeMultiLineBreak = content => {
        const maxNum = this.config.LINE_BREAK_MAX_NUM;
        if (maxNum > 0) {
            const lineBreak = content.indexOf("\r\n") !== -1 ? "\r\n" : "\n";
            const regexp = new RegExp(`(${lineBreak}){${maxNum + 1},}`, "g");
            const breaks = lineBreak.repeat(maxNum);
            content = content.replace(regexp, breaks);
        }
        return content;
    }

    formatAndRemoveMultiLineBreak = content => this.removeMultiLineBreak(this.formatContent(content));

    formatSelection = async () => {
        ClientCommand.copyAsMarkdown();
        const content = await window.parent.navigator.clipboard.readText();
        const formattedContent = this.formatAndRemoveMultiLineBreak(content);
        await window.parent.navigator.clipboard.writeText(formattedContent);
        ClientCommand.paste();
    }

    formatFile = async () => await this.utils.editCurrentFile(this.formatAndRemoveMultiLineBreak)

    call = async () => {
        this.utils.notification.show("混排优化中，请稍等", "info");
        await File.saveUseNode();
        const rangy = File.editor.selection.getRangy();
        if (this.config.FORMAT_IN_SELECTION_ONLY && rangy && ! rangy.collapsed) {
            await this.formatSelection();
        } else {
            await this.formatFile();
        }
        this.utils.notification.show("混排优化完成");
    }
}

module.exports = {
    plugin: mdPaddingPlugin
};
~~~

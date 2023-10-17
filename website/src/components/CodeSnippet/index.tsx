import React from "react";
import CodeBlock from "@theme/CodeBlock";

export function trimSnippet(snippet: string, section: string | undefined, metastring: string | undefined): string {

    if (section != undefined) {
        let sectionMarker = `// ${section}`;

        let sectionStart = snippet.indexOf(sectionMarker);

        console.log(sectionStart);

        if (sectionStart >= 0) {
            // Remove the entire line with the section marker
            while (snippet[sectionStart] != '\n') {
                sectionStart += 1;
            }

            sectionStart += 1;
        }

        let sectionEnd = snippet.indexOf(sectionMarker, sectionStart + 1);

        if (0 <= sectionStart) {
            snippet = snippet
                .substring(sectionStart, sectionEnd >= 0 ? sectionEnd : undefined)
                .trimEnd();

            var lines = snippet.split('\n');

            if (lines.length > 0) {

                while (lines[0].length == 0) {
                    lines.shift();
                }

                let indentN = lines[0].search(/\S|$/);

                return lines.map((l) => {
                    if (l == '\n') {
                        return l;
                    } else {
                        return l.substring(indentN);
                    }
                }).join('\n');
            }

            return snippet;
        } else {
            return "// Oops! Snippet not found!";
        }
    }

    return snippet;
}

interface CodeSnippetProps {
    title?: string;
    snippet: string;
    section?: string;
    metastring?: string;
}

export const CodeSnippet: React.FC<CodeSnippetProps> = ({ snippet, title, section, metastring }) => {

    if (title == undefined || title == "") {
        return <CodeBlock metastring={metastring}>{trimSnippet(snippet, section, metastring)}</CodeBlock>;
    } else {
        return (
            <div className={`snippet`}>
                <div className="snippet__title_bar">
                    <div className="snippet__dots">
                        <div className="snippet__dot"></div>
                        <div className="snippet__dot"></div>
                        <div className="snippet__dot"></div>
                    </div>
                    <div className="snippet__title">{title}</div>
                </div>
                <CodeBlock metastring={metastring}>{trimSnippet(snippet, section, metastring)}</CodeBlock>
            </div>
        );
    }

};
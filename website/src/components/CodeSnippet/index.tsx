import React from "react";
import CodeBlock from "@theme/CodeBlock";

export function trimSnippet(snippet: string, section: string | undefined): string {

    if (section != undefined) {
        let sectionMarker = `/// ${section}`;

        let sectionStart = snippet.indexOf(sectionMarker);

        if (sectionStart > 0) {
            // Remove the entire line with the section marker
            while (snippet[sectionStart] != '\n') {
                sectionStart += 1;
            }
        }

        let sectionEnd = snippet.indexOf(sectionMarker, sectionStart + 1);

        if (0 <= sectionStart) {
            return snippet
                .substring(sectionStart, sectionEnd >= 0 ? sectionEnd : undefined)
                .trim();
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
}

export const CodeSnippet: React.FC<CodeSnippetProps> = ({ snippet, title, section }) => {

    if (title == undefined || title == "") {
        return <CodeBlock>{trimSnippet(snippet, section)}</CodeBlock>;
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
                <CodeBlock>{trimSnippet(snippet, section)}</CodeBlock>
            </div>
        );
    }

};
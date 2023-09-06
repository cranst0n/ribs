import React from "react";
import CodeBlock from "@theme/CodeBlock";

export function trimSnippet(snippet: string, section: string | undefined): string {

    if (section != null) {
        let sectionMarker = `/// ${section}\n`;

        let sectionStart = snippet.indexOf(sectionMarker);
        let sectionEnd = snippet.indexOf(sectionMarker, sectionStart + 1);

        if (0 <= sectionStart) {
            return snippet
                .substring(sectionStart + sectionMarker.length, sectionEnd >= 0 ? sectionEnd : undefined)
                .trim();
        } else {
            return "";
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
};
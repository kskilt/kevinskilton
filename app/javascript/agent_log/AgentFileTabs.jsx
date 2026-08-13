import { useState } from "react";

export default function AgentFileTabs({ files }) {
  const [activeIndex, setActiveIndex] = useState(0);
  const active = files[activeIndex];

  return (
    <div>
      <div className="mb-4 flex flex-wrap gap-2" role="tablist" aria-label="Agent definition files">
        {files.map((file, index) => (
          <button
            key={file.name}
            type="button"
            role="tab"
            aria-selected={index === activeIndex}
            onClick={() => setActiveIndex(index)}
            className={
              "rounded-full px-4 py-2 text-sm font-semibold transition-colors " +
              (index === activeIndex
                ? "bg-cyan-700 text-white"
                : "bg-slate-900/5 text-slate-700 hover:bg-slate-900/10")
            }
          >
            {file.label}
          </button>
        ))}
      </div>

      <pre className="overflow-x-auto rounded-2xl bg-slate-900 p-5 text-sm leading-relaxed text-slate-200">
        <code>{active.content}</code>
      </pre>
    </div>
  );
}

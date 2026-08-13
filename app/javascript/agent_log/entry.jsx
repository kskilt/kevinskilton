import { createRoot } from "react-dom/client";
import AgentFileTabs from "./AgentFileTabs";

const mountEl = document.getElementById("agent-log-tabs");
const dataEl = document.getElementById("agent-log-data");

if (mountEl && dataEl) {
  const files = JSON.parse(dataEl.textContent);
  createRoot(mountEl).render(<AgentFileTabs files={files} />);
}

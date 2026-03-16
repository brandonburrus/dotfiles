import type { Plugin } from "@opencode-ai/plugin"
import { writeFileSync } from "fs"

export const GhosttyTabTitle: Plugin = async () => {
  const setTitle = (title: string) => {
    try {
      writeFileSync("/dev/tty", `\x1b]0;${title}\x07`)
    } catch {
      // Silently ignore if not running in a terminal
    }
  }

  return {
    event: async ({ event }) => {
      if (event.type === "session.created") {
        setTitle("opencode")
      } else if (event.type === "session.updated") {
        const title = event.properties.info.title
        setTitle(title || "opencode")
      } else if (event.type === "session.deleted") {
        setTitle("opencode")
      }
    },
  }
}

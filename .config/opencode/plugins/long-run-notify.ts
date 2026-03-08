import type { Plugin } from "@opencode-ai/plugin"
import { sendAlert } from "node-macos-alerter"
import { homedir } from "os"
import { join, basename } from "path"

const THRESHOLD_MS = 60_000
const APP_ICON = join(homedir(), ".config", "ghostty", "Ghostty.icns")

const sessionStart = new Map<string, number>()

export const LongRunNotify: Plugin = async ({ project }) => ({
  event: async ({ event }) => {
    if (event.type === "session.created") {
      sessionStart.set(event.properties.info.id, Date.now())
    }

    if (event.type === "session.idle") {
      const start = sessionStart.get(event.properties.sessionID)
      if (!start) return
      const elapsed = Date.now() - start
      sessionStart.delete(event.properties.sessionID)

      if (elapsed >= THRESHOLD_MS) {
        await sendAlert({
          title: "OpenCode",
          message: `${basename(project.worktree)} is done`,
          appIcon: APP_ICON,
          group: "opencode-long-run",
          sound: "default",
        })
      }
    }
  },
})

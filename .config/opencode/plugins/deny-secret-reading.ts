import { Plugin } from "@opencode-ai/plugin"

export const DenySecretReads: Plugin = async () => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool === "read") {
        if (output.args.filePath.includes(".env") && output.args.filePath !== "example.env") {
          throw new Error("Don't read .env secrets")
        }
      }
    },
  }
}

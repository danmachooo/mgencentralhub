// src/server.ts
import app from "./app"
import Logger from "./utils/logger"

const PORT = 8000

app.listen(PORT, () => {
	Logger.info(`Microgenesis Central Hub API running on port ${PORT}`)
})

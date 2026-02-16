import "dotenv/config"
import { z } from "zod"

const envSchema = z.object({
	PORT: z.coerce.number().default(8000),
	BASE_URL: z.string().min(1),
	NODE_ENV: z.enum(["development", "production", "test"]).default("development"),
	DATABASE_URL: z.string().min(1),
	FRONTEND_URL: z.string().min(1),
	BETTER_AUTH_SECRET: z.string().min(1),
	BETTER_AUTH_URL: z.string().min(1),
	AZURE_AD_CLIENT_ID: z.string().min(1),
	AZURE_AD_CLIENT_SECRET: z.string().min(1),
	AZURE_AD_TENANT_ID: z.string().min(1),
	AZURE_AD_REDIRECT_URI: z.string().min(1),
})

function validateEnv() {
	const parsed = envSchema.safeParse(process.env)

	if (!parsed.success) {
		console.error("Invalid environment variables:")

		parsed.error.issues.forEach(issue => {
			console.error(`  ${issue.path.join(".")}: ${issue.message}`)
		})

		// Fail fast — app should not run with invalid config
		throw new Error("Invalid environment variables")
	}

	return parsed.data
}
export const env = validateEnv()

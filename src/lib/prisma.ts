import "dotenv/config"
import { PrismaPg } from "@prisma/adapter-pg"
import { appConfig } from "@/config/appConfig"
import { PrismaClient } from "@prisma/client"

const connectionString = appConfig.database.url

const adapter = new PrismaPg({ connectionString })
const prisma = new PrismaClient({ adapter })

export { prisma }

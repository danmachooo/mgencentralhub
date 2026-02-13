import { betterAuth } from "better-auth";
import { prismaAdapter } from "better-auth/adapters/prisma";
import {prisma} from './prisma'
import { appConfig } from "../../config/appConfig";


export const auth = betterAuth({
    database: prismaAdapter(prisma, {
        provider: "postgresql"
    }),
    emailAndPassword: { 
        enabled: true, 
    }, 
    socialProviders: { 
        microsoft: { 
            clientId: appConfig.auth.azure.clientId, 
            clientSecret: appConfig.auth.azure.clientSecret,
            tenantId: appConfig.auth.azure.tenantId,
            authority: "https://login.microsoftonline.com",
            prompt: "select_account"
    }, 
  }, 
})


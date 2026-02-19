import type { CreateSystemInput, CreatorIdentifier, SystemIdentifier, UpdateSystemInput } from "@/schema"
import { getUserAccessContext } from "@/features/UserProfiles/services/userProfile.service"
import { NotFoundError } from "@/errors"
import { createSystem, getSystem, updateSystem } from "@/features/Systems/repos/system.repo"
import { withPrismaErrorHandling } from "@/helpers/prisma"

export async function createCompanySystem(creator: CreatorIdentifier, data: CreateSystemInput) {
	const ctx = await getUserAccessContext(creator)

	if (!ctx) throw new NotFoundError("User was not found.")

	// return await createSystem(ctx.userId, data)

	return withPrismaErrorHandling(() => createSystem(ctx.userId, data), {
		entity: "System",
		uniqueFieldLabels: {
			name: "system name",
			url: "system url",
		},
	})
}
export async function updateCompanySystem(system: SystemIdentifier, data: UpdateSystemInput) {
	return withPrismaErrorHandling(() => updateSystem(system.id, data), {
		entity: "System",
		uniqueFieldLabels: {
			name: "system name",
			url: "system url",
		},
		notFoundMessage: "System not found.",
		uniqueConstraintToField: {
			systems_url_key: "url",
			systems_name_key: "name",
		},
	})
}

export async function getCompanySystem(system: SystemIdentifier) {
	return withPrismaErrorHandling(() => getSystem(system.id), {
		entity: "System",
		notFoundMessage: "System not found.",
	})
}

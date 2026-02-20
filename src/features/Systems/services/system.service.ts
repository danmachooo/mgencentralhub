import type { CreateSystemInput, CreatorIdentifier, SystemIdentifier, UpdateSystemInput } from "@/schema"
import { getUserAccessContext } from "@/features/UserProfiles/services/userProfile.service"
import { NotFoundError } from "@/errors"
import { createSystem, getSystemById, getSystems, updateSystem } from "@/features/Systems/repos/system.repo"
import { withPrismaErrorHandling } from "@/helpers/prisma"

export async function createCompanySystem(creator: CreatorIdentifier, data: CreateSystemInput) {
	const ctx = await getUserAccessContext(creator)

	if (!ctx) throw new NotFoundError("User was not found.")

	// return await createSystem(ctx.userId, data)

	return withPrismaErrorHandling(() => createSystem(ctx.userId, data), {
		entity: "System",
		uniqueFieldLabels: {
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
		uniqueConstraintToField: {
			systems_url_key: "url",
			systems_name_key: "name",
		},
	})
}

export async function getCompanySystems() {
	return withPrismaErrorHandling(() => getSystems(), {
		entity: "System"
	})
}

export async function getCompanySystemByID(system: SystemIdentifier) {
	return withPrismaErrorHandling(() => getSystemById(system.id), {
		entity: "System",
	})
}

import { prisma } from "@/lib/prisma"
import type { CreateSystemInput, UpdateSystemInput } from "@/schema"
import type { Prisma } from "@prisma/client"

export async function createSystem(id: string, data: CreateSystemInput) {
	const departmentIds = [...new Set(data.departmentIds)]

	return prisma.$transaction(async (tx: Prisma.TransactionClient) => {
		const systemCreated = await tx.system.create({
			data: {
				name: data.name,
				description: data.description,
				url: data.url,
				image: data.image,
				status: data.status,
				creatorId: id,
				departmentMap: {
					create: departmentIds.map(departmentId => ({ departmentId })),
				},
			},
			select: {
				id: true,
			},
		})
		return systemCreated
	})
}

export async function updateSystem(id: string, data: UpdateSystemInput) {
	const departmentIds = data.departmentIds ? [...new Set(data.departmentIds)] : undefined

	return prisma.$transaction(async (tx: Prisma.TransactionClient) => {
		const systemUpdated = await tx.system.update({
			where: {
				id: id,
			},
			data: {
				name: data.name,
				description: data.description,
				url: data.url,
				image: data.image,
				status: data.status,
			},
			select: {
				id: true,
			},
		})

		if (departmentIds) {
			await tx.systemDepartmentMap.deleteMany({
				where: {
					systemId: id,
				},
			})

			if (departmentIds.length > 0) {
				await tx.systemDepartmentMap.createMany({
					data: departmentIds.map(departmentId => ({
						systemId: id,
						departmentId,
					})),
					skipDuplicates: true,
				})
			}
		}

		return systemUpdated
	})
}

export async function isSystemExist(id: string) {
	const found = await prisma.system.findUniqueOrThrow({
		where: {
			id,
		},
		select: {
			id: true,
		},
	})

	return !!found
}

export async function getSystem(id: string) {
	const system = await prisma.system.findUniqueOrThrow({
		where: {
			id,
		},
		select: {
			id: true,
			name: true,
			description: true,
			status: true,
			url: true,
			createdAt: true,
			updatedAt: true,
			departmentMap: {
				select: {
					departmentId: true,
				},
			},
		},
	})

	return system
}

export async function listActiveCompanySystemsForAdmin() {
	return await prisma.system.findMany({
		where: {
			status: "ACTIVE",
		},
		select: {
			id: true,
			name: true,
			description: true,
			url: true,
			image: true,
		},
		orderBy: {
			name: "asc",
		},
	})
}

export async function listActiveCompanySystemsForDepartment(departmentId: string) {
	return await prisma.system.findMany({
		where: {
			status: "ACTIVE",
			departmentMap: {
				some: {
					departmentId,
				},
			},
		},
		select: {
			id: true,
			name: true,
			description: true,
			url: true,
			image: true,
		},
		orderBy: {
			name: "asc",
		},
	})
}

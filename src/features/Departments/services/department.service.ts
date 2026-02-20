import type { CreateDepartmentInput, DepartmentIdentifier, UpdateDepartmentInput } from "@/schema"
import { createDepartment, getDepartmentByID, getDepartments, updateDepartment } from "@/features/Departments/repos/department.repo"

export async function createCompanyDepartment(data: CreateDepartmentInput) {
	return await createDepartment(data)
}

export async function updateCompanyDepartment(department: DepartmentIdentifier, data: UpdateDepartmentInput) {
	const { id } = department

	return await updateDepartment(id, data)
}

export async function getCompanyDepartments() {
	return await getDepartments();
}

export async function getCompanyDepartmentbyID(department: DepartmentIdentifier) {
	const {id} =department

	return await getDepartmentByID(id)
}
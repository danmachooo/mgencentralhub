import {
	createDepartmentHandler,
	getCompanyDepartmentbyIDHandler,
	getCompanyDepartmentsHandler,
	updateDepartmentHandler,
} from "@/features/Departments/department.controller"
import { Router } from "express"

const router = Router()

router.get("/", getCompanyDepartmentsHandler)
router.get("/:id", getCompanyDepartmentbyIDHandler)
router.post("/", createDepartmentHandler)
router.patch("/:id", updateDepartmentHandler)

export default router

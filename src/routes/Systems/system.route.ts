import {
	createCompanySystemHandler,
	getCompanySystemHandler,
	updateCompanySystemHandler,
} from "@/features/Systems/controllers/system.controller"
import { Router } from "express"

const router = Router()

router.get("/:id", getCompanySystemHandler)
router.post("/", createCompanySystemHandler)
router.patch("/:id", updateCompanySystemHandler)

export default router

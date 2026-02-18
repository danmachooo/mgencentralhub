import { Router } from "express"
import HealthRouter from "./health.route"
import SystemRouter from "./Systems/system.route"
import DepartmentRouter from "./Departments/department.route"
import AuthTestRouter from "./AuthTest/authTest.route"

const router = Router()

// Use to check health route
router.use("/health", HealthRouter)

router.use("/auth-test", AuthTestRouter)

router.use("/system", SystemRouter)
router.use("/department", DepartmentRouter)

export default router

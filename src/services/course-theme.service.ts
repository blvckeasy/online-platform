import { ICourseTheme, IGetCourseThemeInput } from "../interfaces/course-theme.interface";
import ErrorHandler from "../utils/error-handler";
import { client } from "../utils/pg";


export class CourseThemeService {
    static async getCourseThemes (getCourseThemeInput: IGetCourseThemeInput = {}): Promise<ICourseTheme[]> {
        try {
            const { id, course_id } = getCourseThemeInput;
            const courseThemes: ICourseTheme[] = (await client.query(`
                SELECT * FROM course_themes
                WHERE
                    id = CASE WHEN $1 > 0 THEN $1 ELSE -1 END OR
                    course_id =  CASE WHEN $2 > 0 THEN $2 ELSE -1 END OR
                    true;
            `, [id, course_id])).rows;

            return courseThemes;
        } catch (error) {
            throw await ErrorHandler(error);
        }
    }
}
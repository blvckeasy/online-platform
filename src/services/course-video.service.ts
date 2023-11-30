import { ICourseVideo, IGetCourseVideoInput } from "../interfaces/course-video.interface";
import ErrorHandler from "../utils/error-handler";
import { client } from "../utils/pg";

export class CourseVideoService {
    static async getCourseVideos (getCourseVideosInput: IGetCourseVideoInput): Promise<ICourseVideo[]> {
        try {
            const { id, theme_id } = getCourseVideosInput;
            const courseVideos: ICourseVideo[] = (await client.query(`
                SELECT * FROM course_videos
                WHERE
                    id = CASE WHEN $1 > 0 THEN $1 ELSE -1 END OR
                    theme_id = CASE WHEN $2 > 0 THEN $2 ELSE -1 END OR
                    true;
            `, [id, theme_id])).rows;

            return courseVideos;
        } catch (error) {
            throw await ErrorHandler(error);
        }
    }
}
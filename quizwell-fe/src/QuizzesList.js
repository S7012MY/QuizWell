import { useEffect, useState } from "react";
import Quiz from "./Quiz";

export default function QuizzesList() {
  const [quizzes, setQuizzes] = useState([]);

  useEffect(() => {
    fetch("/api/quiz/list")
      .then(response => response.json())
      .then(data => {
        if (data.quizzes) {
          setQuizzes(data.quizzes);
        } else {
          console.error("Failed to fetch quizzes");
        }
      })
      .catch(error => {
        console.error("Error fetching quizzes:", error);
      });
  }, []);

  return (
    <div className="container mt-4">
      <h2 className="mb-5">Available Quizzes</h2>
      {quizzes.map(quiz => (
        <Quiz key={quiz.uuid} quiz={quiz} />
      ))}
    </div>
  );
}
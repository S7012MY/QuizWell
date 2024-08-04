import { useEffect, useState } from "react";
import Quiz from "./Quiz";

export default function QuizzesList() {
  const [quizzes, setQuizzes] = useState([]);
  const [filter, setFilter] = useState("");
  const [filteredQuizzes, setFilteredQuizzes] = useState([]);

  useEffect(() => {
    fetch("/api/quiz/list")
      .then(response => response.json())
      .then(data => {
        if (data.quizzes) {
          setQuizzes(data.quizzes);
          setFilteredQuizzes(data.quizzes);
        } else {
          console.error("Failed to fetch quizzes");
        }
      })
      .catch(error => {
        console.error("Error fetching quizzes:", error);
      });
  }, []);

  useEffect(() => {
    if (filter === "") {
      setFilteredQuizzes(quizzes);
    } else {
      const filterTags = filter.split(/[, ]+/).map(tag => tag.toLowerCase());
      setFilteredQuizzes(
        quizzes.filter(quiz =>
          filterTags.every(filterTag =>
            quiz.tags.some(tag => tag.toLowerCase().includes(filterTag))
          )
        )
      );
    }
  }, [filter, quizzes]);

  return (
    <div className="container mt-4">
      <h2 className="mb-5">Available Quizzes</h2>
      <div className="mb-4">
        <input
          type="text"
          className="form-control"
          placeholder="Filter by tags"
          value={filter}
          onChange={e => setFilter(e.target.value)}
        />
      </div>
      {filteredQuizzes.map(quiz => (
        <Quiz key={quiz.uuid} quiz={quiz} />
      ))}
    </div>
  );
}
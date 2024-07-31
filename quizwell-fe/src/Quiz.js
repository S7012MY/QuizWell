import React from "react";
import { useNavigate } from "react-router-dom";
import { startQuiz as startQuizUtil } from "./utils/quiz";

export default function Quiz({ quiz }) {
  const navigate = useNavigate();

  function handleStartQuiz(uuid) {
    startQuizUtil(uuid)
      .then(result => {
        if (result.success) {
          console.log(result);
          navigate(`/quiz/${uuid}`);
        } else {
          console.error(result.error);
        }
      });
  }

  return (
    <div className="card mb-4">
      <div className="card-body">
        <h5 className="card-title">Quiz UUID: {quiz.uuid}</h5>
        <div className="card-text">
          {quiz.tags.map((tag, index) => (
            <div key={index}>{tag}</div>
          ))}
        </div>
        <div className="card-footer bg-transparent mt-3">
          <button className="btn btn-secondary" onClick={() =>
            handleStartQuiz(quiz.uuid)}>Take Quiz</button>
        </div>
      </div>
    </div>
  );
}
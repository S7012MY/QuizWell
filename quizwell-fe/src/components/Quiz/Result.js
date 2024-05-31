import { useEffect, useState } from "react";

export default function QuizResult({ quizUuid }) {
  const [questionData, setQuestionData] = useState([]);
  const [correctAnswers, setCorrectAnswers] = useState(0);
  const [duration, setDuration] = useState("");

  useEffect(() => {
    fetch(`/api/quiz/${quizUuid}/result`)
      .then(response => response.json())
      .then(data => {
        if (!data.error) {
          let correctAnswers = 0;
          setQuestionData(data.questions);
          for (const question of data.questions) {
            let isCorrect = true;
            for (const answer of question.answers) {
              if (answer.is_correct && !question.user_answers.includes(answer.id)) {
                isCorrect = false;
              }
            }
            for (const answer of question.user_answers) {
              if (question.answers.find((a) => a.id === answer && !a.is_correct)) {
                isCorrect = false;
              }
            }
            if (isCorrect) {
              ++correctAnswers;
            }
          }
          setCorrectAnswers(correctAnswers);
        } else {
          console.error(data.error);
        }
      });
      fetch(`/api/quiz/${quizUuid}/status`)
      .then(response => response.json())
      .then(data => {
        if (!data.error) {
          setDuration(data.duration);
          console.log('Duration data: ', data.duration);
        } else {
          console.error(data.error);
        }
      });
  }, [quizUuid]);

  return (
    <div className="container">
      <h1>Quiz Result</h1>
      <br />
      <p>
        Did you like the quiz? <a href="https://buy.stripe.com/28o3ftgQk55Ef9C296">Donate $1 here</a> to keep it running.
      </p>
      <div className="card">
        <div className="card-header">Your results</div>
        <div className="card-body">
          <div>Correct answers: {correctAnswers}</div>
          <div>Total questions: {questionData.length}</div>
          <div>Percentage: {correctAnswers / questionData.length * 100}%</div>
          <div>Quiz duration (HH:MM:SS): {duration}</div>
        </div>
      </div>


      {questionData.map((question) => (
        <div key={question.id} className="card">
          <div className="card-header" dangerouslySetInnerHTML={{ __html: question.text }}></div>
          <div className="card-body">
            <div className="list-group">
              {question.answers.map((answer) => (
                <div key={answer.id} className="list-group-item">
                  <div>{answer.md}</div>
                  { answer.is_correct === 1 && <div className="badge bg-primary">Correct</div> }
                  { question.user_answers.includes(answer.id) && <div className="badge bg-secondary">Selected</div> }
                </div>
              ))}
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}
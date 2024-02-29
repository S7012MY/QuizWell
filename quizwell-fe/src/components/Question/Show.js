import { useEffect, useState } from "react";

export default function ShowQuestion({ idx, nextQuestion, quizUuid }) {
  const [question, setQuestion] = useState('');
  const [answers, setAnswers] = useState([]);
  const [selectedAnswers, setSelectedAnswers] = useState([]);

  useEffect(() => {
    fetch(`/api/quiz/${quizUuid}/question`)
      .then(response => response.json())
      .then(data => {
        if (!data.error) {
          console.log(data);
          setQuestion(data.question);
          setAnswers(data.answers);
        } else {
          console.error(data.error);
        }
      });
  }, [idx]);

  function submitAnswer() {
    fetch(`/api/quiz/${quizUuid}/answer`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ answerIds: selectedAnswers })
    })
      .then(response => response.json())
      .then(data => {
        if (!data.error) {
          console.log(data);
          setSelectedAnswers([]);
          nextQuestion(data.hasNextQuestion);
        } else {
          console.error(data.error);
        }
      });
  }

  return (
    <div>
      {question && 
        <div>
          <div dangerouslySetInnerHTML={{ __html: question }}></div>
          <div className="form-check">
            {answers.map((answer) => (
              <div key={answer.id} className="form-check">
                { /* TODO fix uncontrolled component */ }
                <input
                  type="checkbox"
                  className="form-check-input"
                  id={answer.id}
                  value={answer.id}
                  onChange={(e) => {
                    if (e.target.checked) {
                      setSelectedAnswers([...selectedAnswers, answer.id]);
                    } else {
                      setSelectedAnswers(selectedAnswers.filter((id) => id !== answer.id));
                    }
                  }}
                />
                <label className="form-check-label" htmlFor={answer.id}>
                  <div dangerouslySetInnerHTML={{ __html: answer.md }}></div>
                </label>
              </div>
            ))}
          </div>
          <button className="btn btn-primary" onClick={submitAnswer}>
            Submit Answer
          </button>
        </div>
      }
    </div>
  );
}
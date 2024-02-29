import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import ShowQuestion from "../../components/Question/Show";
import QuizResult from "../../components/Quiz/Result";

export default function ShowQuiz() {
  const quizUuid = useParams().uuid;
  const [status, setStatus] = useState('LOADING');
  const [questionIdx, setQuestionIdx] = useState(-1);

  useEffect(() => {
    fetch(`/api/quiz/${quizUuid}/status`)
      .then(response => response.json())
      .then(data => {
        if (!data.error) {
          console.log(data);
          setStatus(data.status);
        } else {
          console.error(data.error);
        }
      });
  }, [quizUuid]);

  function nextQuestion(hasNextQuestion) {
    setQuestionIdx(questionIdx + 1);
    if (!hasNextQuestion) {
      setStatus('COMPLETED');
    }
  }

  function startQuiz() {
    fetch(`/api/quiz/${quizUuid}/start`, { method: 'POST' })
      .then(response => response.json())
      .then(data => {
        if (!data.error) {
          console.log(data);
          setStatus('IN_PROGRESS');
          setQuestionIdx(0);
        } else {
          console.error(data.error);
        }
      });
  }

  return (
    <div>
      {status === 'LOADING' && <div>Loading...</div>}
      {status === 'NOT_STARTED' && 
        <div className="card">
          <div className="card-header">Your quiz is ready</div>
          <div className="card-body">
            <button className="btn btn-primary" onClick={startQuiz}>
              Start Quiz
            </button>
          </div>
        </div>
      }
      {status === 'IN_PROGRESS' && 
        <ShowQuestion idx={questionIdx} nextQuestion={nextQuestion} quizUuid={quizUuid}/>
      }
      {status === 'COMPLETED' && <QuizResult quizUuid={quizUuid}/> }
    </div>
  );
}
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import ShowQuestion from "../../components/Question/Show";
import QuizResult from "../../components/Quiz/Result";
import { startQuiz as startQuizUtil } from "../../utils/quiz";

export default function ShowQuiz() {
  const quizUuid = useParams().uuid;
  const [status, setStatus] = useState('LOADING');
  const [questionIdx, setQuestionIdx] = useState(-1);

  function fetchWithTimeout(url, options, timeout = 70000) {
    const controller = new AbortController();
    const signal = controller.signal;
  
    options = {...options, signal };
  
    const timeoutPromise = new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        clearTimeout(timer);
        controller.abort();
        reject(new Error('Request timed out'));
      }, timeout);
    });
  
    return Promise.race([
      fetch(url, options),
      timeoutPromise,
    ]);
  }

  useEffect(() => {
    fetchWithTimeout(`/api/quiz/${quizUuid}/status`, {}, 120000)
      .then(response => response.json())
      .then(data => {
        if (!data.error) {
          console.log(data);
          setStatus(data.status);
        } else {
          alert(data.error);
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

  function handleStartQuiz() {
    startQuizUtil(quizUuid)
      .then(result => {
        if (result.success) {
          console.log(result);
          setStatus("IN_PROGRESS");
          setQuestionIdx(0);
        } else {
          console.error(result.error);
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
            <button className="btn btn-primary" onClick={handleStartQuiz}>
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
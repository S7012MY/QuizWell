import { useEffect, useState } from "react";

export default function ShowQuestion({ idx, nextQuestion, quizUuid }) {
  const [question, setQuestion] = useState('');
  const [answers, setAnswers] = useState([]);
  const [selectedAnswers, setSelectedAnswers] = useState([]);
  const [isSubmitting, setIsSubmitting] = useState(false);

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
    if (selectedAnswers.length === 0) {
      alert('Please select at least one answer');
      return;
    }
    setIsSubmitting(true);
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

  function formatCodeInHtml(text) {
    // Replace <br> with \n
    text = text.replace(/<br>/g, '\n');
    // Replace <code> with <pre> and </code> with </pre>
    text = text.replace(/<code>/g, '<pre>').replace(/<\/code>/g, '</pre>');
    // Replace < with &lt; inside <pre>
    text = text.replace(/<pre>(.*?)<\/pre>/gs, (match, p1) => `<pre>${p1.replace(/</g, '&lt;')}</pre>`);
    // 
    return text;
  }

  return (
    <div>
      {question && 
        <div>
          <div dangerouslySetInnerHTML={{ __html: formatCodeInHtml(question) }}></div>
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
                  <div dangerouslySetInnerHTML={{ __html: formatCodeInHtml(answer.md) }}></div>
                </label>
              </div>
            ))}
          </div>
          {!isSubmitting && <button className="btn btn-primary" onClick={submitAnswer}>
            Submit Answer
          </button>}
        </div>
      }
    </div>
  );
}
export function startQuiz(uuid) {
  return fetch(`/api/quiz/${uuid}/start`, { method: "POST" })
    .then(response => response.json())
    .then(data => {
      if (!data.error && data.status === "ok") {
        return { success: true, status: data.status };
      } else {
        console.error("Failed to start quiz:", data.error);
        return { success: false, error: data.error };
      }
    })
    .catch(error => {
      console.error("Error starting quiz:", error);
      return { success: false, error };
    });
}
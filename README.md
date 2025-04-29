<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Bingo Game - README</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background-color: #f4f6f8;
      color: #333;
      max-width: 800px;
      margin: 40px auto;
      padding: 20px;
      line-height: 1.6;
      border-radius: 10px;
      background: white;
      box-shadow: 0 0 20px rgba(0,0,0,0.1);
    }
    h1, h2 {
      color: #2c3e50;
    }
    code {
      background: #eef;
      padding: 2px 6px;
      border-radius: 4px;
    }
    pre {
      background: #f0f0f0;
      padding: 10px;
      overflow: auto;
      border-radius: 5px;
    }
    ul {
      margin-left: 20px;
    }
    .highlight {
      color: #e74c3c;
      font-weight: bold;
    }
    .tech-stack, .structure {
      background: #fafafa;
      border-left: 4px solid #3498db;
      padding: 10px 15px;
      margin: 15px 0;
      border-radius: 5px;
    }
  </style>
</head>
<body>

  <h1>🎯 Bingo Game (2-Player)</h1>

  <p>A fun and competitive 2-player Bingo game using a 5x5 grid. Each player marks numbers from 1 to 25 aiming to complete lines and spell <strong>BINGO</strong>.</p>

  <h2>🎮 Gameplay Rules</h2>
  <ul>
    <li>Each player gets a 5x5 grid with numbers 1 to 25.</li>
    <li>Players <span class="highlight">take turns</span> calling out numbers.</li>
    <li>Numbers are marked on <strong>both</strong> boards.</li>
    <li>Line completion gives letters of <code>BINGO</code>:
      <ul>
        <li>1st Line → <strong>B</strong></li>
        <li>2nd Line → <strong>I</strong></li>
        <li>3rd Line → <strong>N</strong></li>
        <li>4th Line → <strong>G</strong></li>
        <li>5th Line → <strong>O</strong></li>
      </ul>
    </li>
    <li>Completing all 5 lines = <strong>BINGO</strong> = <span class="highlight">Win!</span></li>
    <li>If both complete together → <strong>Draw</strong></li>
  </ul>

  <h2>🎨 Features</h2>
  <ul>
    <li>Local 2-player mode</li>
    <li>Randomized board generation</li>
    <li>Color-coded tracking: <span style="color:red;">Red</span> (You), <span style="color:blue;">Blue</span> (Opponent)</li>
    <li>Line detection logic</li>
  </ul>

  <h2>🛠️ Tech Stack</h2>
  <div class="tech-stack">
    <ul>
      <li><strong>Language:</strong> Dart (Flutter)</li>
      <li><strong>State:</strong> Local variables</li>
      <li><strong>UI:</strong> GridView-based matrix layout</li>
    </ul>
  </div>

  <h2>🚀 How to Run</h2>
  <pre></pre>

  <hr>
  <p><strong>Enjoy the game — and may the best Bingo master win!</strong></p>

</body>
</html>

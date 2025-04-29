@ -1,54 +0,0 @@
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
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

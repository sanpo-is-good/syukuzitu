<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>記念日発明所 — The Anniversary Invention Lab | Prototype</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  html, body {
    height: 100%;
    background: #0a0a0a;
    color: #f4f2ea;
    font-family: "Hiragino Sans", "Noto Sans JP", -apple-system, BlinkMacSystemFont, sans-serif;
    overflow: hidden;
  }
  body {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    position: relative;
  }
  /* falling memories in background */
  #memory-sky {
    position: fixed;
    inset: 0;
    overflow: hidden;
    z-index: 0;
    pointer-events: none;
  }
  .memory {
    position: absolute;
    font-family: "Hiragino Mincho ProN", "Yu Mincho", serif;
    font-style: italic;
    color: rgba(255,255,255,0.18);
    font-size: 11px;
    white-space: nowrap;
    animation: fall linear infinite;
  }
  @keyframes fall {
    from { transform: translateY(-20vh); opacity: 0; }
    10% { opacity: 0.5; }
    90% { opacity: 0.5; }
    to { transform: translateY(120vh); opacity: 0; }
  }
  /* central flower */
  .flower {
    position: relative;
    width: 140px;
    height: 140px;
    margin-bottom: 2.5rem;
    z-index: 2;
  }
  .flower::after {
    content: "";
    position: absolute;
    inset: 0;
    background: radial-gradient(circle, rgba(242,195,94,0.25) 0%, rgba(242,195,94,0.05) 40%, transparent 70%);
    animation: pulse 3s ease-in-out infinite;
  }
  @keyframes pulse {
    0%,100% { transform: scale(1); opacity: 0.7; }
    50% { transform: scale(1.15); opacity: 1; }
  }
  .flower svg {
    position: relative;
    z-index: 1;
  }

  /* scene container */
  .scene {
    position: relative;
    z-index: 2;
    max-width: 640px;
    width: 90%;
    text-align: center;
    padding: 2rem;
  }
  .scene.fade-out { animation: fadeOut 0.6s forwards; }
  .scene.fade-in { animation: fadeIn 0.8s forwards; }
  @keyframes fadeOut { to { opacity: 0; transform: translateY(-12px); } }
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(12px); }
    to { opacity: 1; transform: translateY(0); }
  }

  h1.tagline {
    font-family: "Hiragino Mincho ProN", "Yu Mincho", serif;
    font-size: clamp(28px, 4vw, 38px);
    font-weight: 500;
    letter-spacing: 0.08em;
    margin-bottom: 0.5rem;
    color: #f4f2ea;
  }
  p.subtitle {
    font-size: 12px;
    letter-spacing: 0.3em;
    color: #888780;
    margin-bottom: 3rem;
  }
  p.lead {
    font-family: "Hiragino Mincho ProN", "Yu Mincho", serif;
    font-size: 18px;
    line-height: 2;
    color: #d8d6ce;
    margin-bottom: 3rem;
  }

  button.primary {
    background: transparent;
    border: 1px solid #f4f2ea;
    color: #f4f2ea;
    padding: 14px 44px;
    font-size: 13px;
    letter-spacing: 0.25em;
    cursor: pointer;
    font-family: inherit;
    transition: all 0.3s ease;
  }
  button.primary:hover {
    background: #f4f2ea;
    color: #0a0a0a;
  }
  button.primary:disabled { opacity: 0.3; cursor: not-allowed; }

  /* question phase */
  .question-counter {
    font-size: 10px;
    letter-spacing: 0.3em;
    color: #888780;
    margin-bottom: 1.5rem;
  }
  .question-text {
    font-family: "Hiragino Mincho ProN", "Yu Mincho", serif;
    font-size: clamp(18px, 2.5vw, 24px);
    line-height: 1.9;
    color: #f4f2ea;
    margin-bottom: 2rem;
    min-height: 4.5em;
  }
  textarea.answer {
    width: 100%;
    max-width: 500px;
    min-height: 80px;
    background: transparent;
    border: none;
    border-bottom: 1px solid #5f5e5a;
    color: #f4f2ea;
    padding: 12px 4px;
    font-size: 15px;
    font-family: inherit;
    line-height: 1.8;
    resize: none;
    outline: none;
    transition: border-color 0.3s;
    text-align: center;
  }
  textarea.answer:focus { border-bottom-color: #f2c35e; }
  textarea.answer::placeholder { color: #5f5e5a; font-style: italic; }
  .btn-row {
    display: flex;
    gap: 1rem;
    justify-content: center;
    margin-top: 2rem;
  }
  button.ghost {
    background: transparent;
    border: 1px solid #5f5e5a;
    color: #888780;
    padding: 10px 28px;
    font-size: 12px;
    letter-spacing: 0.2em;
    cursor: pointer;
    font-family: inherit;
    transition: all 0.3s;
  }
  button.ghost:hover { border-color: #f4f2ea; color: #f4f2ea; }

  /* progress */
  .progress-bar {
    width: 120px;
    height: 1px;
    background: #2c2c2a;
    margin: 0 auto 2.5rem;
    position: relative;
  }
  .progress-fill {
    position: absolute;
    left: 0; top: 0;
    height: 100%;
    background: #f2c35e;
    transition: width 0.5s ease;
  }

  /* result phase */
  .result-label {
    font-size: 10px;
    letter-spacing: 0.3em;
    color: #888780;
    margin-bottom: 1rem;
  }
  .invented-name {
    font-family: "Hiragino Mincho ProN", "Yu Mincho", serif;
    font-size: clamp(26px, 4vw, 36px);
    font-weight: 500;
    line-height: 1.5;
    color: #f4f2ea;
    margin-bottom: 1rem;
    letter-spacing: 0.04em;
  }
  .invented-date {
    font-family: "Hiragino Mincho ProN", "Yu Mincho", serif;
    font-size: 16px;
    color: #f2c35e;
    letter-spacing: 0.15em;
    margin-bottom: 2.5rem;
  }
  .flower-name {
    font-size: 13px;
    letter-spacing: 0.2em;
    color: #d8d6ce;
    margin-bottom: 0.5rem;
  }
  .flower-meaning {
    font-family: "Hiragino Mincho ProN", "Yu Mincho", serif;
    font-style: italic;
    font-size: 13px;
    color: #888780;
    margin-bottom: 3rem;
  }
  .divider {
    width: 60px;
    height: 1px;
    background: #5f5e5a;
    margin: 2rem auto;
  }

  /* footer brand */
  .footer-brand {
    position: fixed;
    bottom: 20px;
    left: 0; right: 0;
    text-align: center;
    font-size: 9px;
    letter-spacing: 0.3em;
    color: #444441;
    z-index: 1;
  }
  .intro-header {
    position: fixed;
    top: 24px;
    left: 0; right: 0;
    text-align: center;
    font-size: 10px;
    letter-spacing: 0.4em;
    color: #5f5e5a;
    z-index: 1;
  }

  .hidden { display: none !important; }
</style>
</head>
<body>

<div id="memory-sky"></div>
<div class="intro-header">J-FLOWER × Hakuhodo DY ONE ─ PROTOTYPE</div>

<!-- ════ SCENE 1: INTRO ════ -->
<div class="scene" id="scene-intro">
  <div class="flower">
    <svg width="140" height="140" viewBox="0 0 140 140">
      <line x1="70" y1="80" x2="70" y2="140" stroke="#f4f2ea" stroke-width="1" opacity="0.6"/>
      <g transform="translate(70 65)">
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f4f2ea" opacity="0.92" transform="rotate(0)"/>
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f4f2ea" opacity="0.92" transform="rotate(60)"/>
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f4f2ea" opacity="0.92" transform="rotate(120)"/>
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f4f2ea" opacity="0.92" transform="rotate(180)"/>
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f4f2ea" opacity="0.92" transform="rotate(240)"/>
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f4f2ea" opacity="0.92" transform="rotate(300)"/>
        <circle r="6" fill="#f2c35e"/>
      </g>
    </svg>
  </div>
  <h1 class="tagline">祝日が、足りない。</h1>
  <p class="subtitle">THE ANNIVERSARY INVENTION LAB</p>
  <p class="lead">
    あなたには、<br>
    誰にも気づかれずに乗り越えた日が、<br>
    あったはずです。
  </p>
  <button class="primary" onclick="startQuestions()">はじめる</button>
</div>

<!-- ════ SCENE 2: QUESTIONS ════ -->
<div class="scene hidden" id="scene-questions">
  <div class="progress-bar"><div class="progress-fill" id="progress" style="width:0%"></div></div>
  <div class="question-counter" id="q-counter">QUESTION 01 / 07</div>
  <div class="question-text" id="q-text"></div>
  <textarea class="answer" id="q-answer" placeholder="自分の言葉で、自由に。"></textarea>
  <div class="btn-row">
    <button class="ghost" onclick="prevQuestion()" id="btn-prev">もどる</button>
    <button class="primary" onclick="nextQuestion()" id="btn-next">つぎへ</button>
  </div>
</div>

<!-- ════ SCENE 3: INVENTING ════ -->
<div class="scene hidden" id="scene-inventing">
  <div class="flower">
    <svg width="140" height="140" viewBox="0 0 140 140" style="animation: pulse 1.5s ease-in-out infinite">
      <line x1="70" y1="80" x2="70" y2="140" stroke="#f4f2ea" stroke-width="1" opacity="0.6"/>
      <g transform="translate(70 65)">
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f2c35e" opacity="0.9" transform="rotate(0)"/>
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f2c35e" opacity="0.9" transform="rotate(60)"/>
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f2c35e" opacity="0.9" transform="rotate(120)"/>
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f2c35e" opacity="0.9" transform="rotate(180)"/>
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f2c35e" opacity="0.9" transform="rotate(240)"/>
        <ellipse cx="0" cy="-14" rx="7" ry="16" fill="#f2c35e" opacity="0.9" transform="rotate(300)"/>
        <circle r="6" fill="#fff"/>
      </g>
    </svg>
  </div>
  <p class="lead" id="inventing-text" style="margin-bottom:0">あなただけの記念日を、発明しています…</p>
</div>

<!-- ════ SCENE 4: RESULT ════ -->
<div class="scene hidden" id="scene-result">
  <div class="result-label">YOUR ANNIVERSARY</div>
  <div class="invented-name" id="result-name"></div>
  <div class="invented-date" id="result-date"></div>
  <div class="divider"></div>
  <div class="flower-name" id="result-flower-name"></div>
  <div class="flower-meaning" id="result-flower-meaning"></div>
  <p style="font-size:11px; color:#888780; letter-spacing:0.15em; margin-bottom:2.5rem; line-height:2">
    この記念日は、全国で発明された<br>
    新しい記念日たちと一緒に、降り積もっていきます。
  </p>
  <button class="primary" onclick="restart()">もう一度、発明する</button>
</div>

<div class="footer-brand">JAPAN FLOWER LIFE PROMOTION ASSOCIATION ─ PROTOTYPE BY I.KAMATANI</div>

<script>
  // ═══ 7 questions (Isseyのコピーライター的筆致) ═══
  const questions = [
    { n: "01", text: "今年、誰にも気づかれなかったけれど、<br>あなたが乗り越えた日はいつでしたか。" },
    { n: "02", text: "最近、自分をこっそり褒めたかった瞬間は、<br>いつでしたか。" },
    { n: "03", text: "思い出したくないのに、<br>思い出に残ってしまった日は、ありましたか。" },
    { n: "04", text: "「私、変わったかも」と感じた瞬間は、<br>いつでしたか。" },
    { n: "05", text: "誰にも言えなかった小さな嬉しさは、<br>ありましたか。" },
    { n: "06", text: "これから、こっそり始めたいことは、<br>ありますか。" },
    { n: "07", text: "1年後の自分に、ひとことだけ送るとしたら？" }
  ];

  // ═══ 花の処方データベース ═══
  const flowers = [
    { name: "ガーベラ", meaning: "希望、常に前進" },
    { name: "スターチス", meaning: "変わらぬ心、永久不変" },
    { name: "ブルースター", meaning: "信じ合う心、幸福な愛" },
    { name: "ラナンキュラス", meaning: "とても魅力的、名誉" },
    { name: "アネモネ", meaning: "期待、はかない恋" },
    { name: "カスミソウ", meaning: "清らかな心、幸福" },
    { name: "ユーカリ", meaning: "新生、記憶" },
    { name: "スイートピー", meaning: "門出、優しい思い出" },
    { name: "トルコキキョウ", meaning: "優美、希望" },
    { name: "プロテア", meaning: "自由自在、王者の風格" }
  ];

  // ═══ 命名ロジック：回答からキーワード抽出して記念日名を合成 ═══
  const nameTemplates = [
    "{verb}日記念日",
    "{adj}{verb}日",
    "ひそかに{verb}日記念日",
    "{adj}自分に、会った日",
    "誰にも言わずに{verb}日",
    "小さく{verb}日記念日"
  ];

  const verbBank = {
    default: ["乗り越えた", "諦めなかった", "許せた", "始めた", "変われた", "選んだ", "気づいた", "うなずいた", "進んだ"],
    positive: ["誇れた", "光った", "ほほえめた", "羽ばたいた", "動いた"],
    reflective: ["見つめなおした", "受け入れた", "手放せた", "抱きしめた"]
  };

  const adjBank = ["新しい", "静かな", "名もなき", "小さな", "まっすぐな", "ひそかな", "はじめての", "たしかな"];

  function detectTone(answers) {
    const text = answers.join(" ");
    const positive = /嬉し|楽し|好き|幸せ|誇|達成|褒|笑|喜|愛/.test(text);
    const reflective = /悩|迷|悲|辛|寂|怖|不安|後悔|泣/.test(text);
    if (reflective) return "reflective";
    if (positive) return "positive";
    return "default";
  }

  function pickRandom(arr) { return arr[Math.floor(Math.random() * arr.length)]; }

  function inventName(answers) {
    const tone = detectTone(answers);
    const verb = pickRandom(verbBank[tone]);
    const adj = pickRandom(adjBank);
    let template = pickRandom(nameTemplates);
    return template.replace("{verb}", verb).replace("{adj}", adj);
  }

  function inventDate() {
    // ユーザーの回答の "いつ" を明示的に聞いていないので、今日+ランダムオフセット で擬似的に記念日化
    const today = new Date();
    const offset = Math.floor(Math.random() * 180) - 90;
    const d = new Date(today.getTime() + offset * 86400000);
    const m = d.getMonth() + 1;
    const day = d.getDate();
    return `${m}月${day}日`;
  }

  // ═══ State ═══
  let currentQ = 0;
  const answers = new Array(7).fill("");

  const qText = document.getElementById("q-text");
  const qCounter = document.getElementById("q-counter");
  const qAnswer = document.getElementById("q-answer");
  const progress = document.getElementById("progress");
  const btnPrev = document.getElementById("btn-prev");
  const btnNext = document.getElementById("btn-next");

  function showQuestion(i) {
    qText.innerHTML = questions[i].text;
    qCounter.textContent = `QUESTION ${questions[i].n} / 07`;
    qAnswer.value = answers[i] || "";
    progress.style.width = `${((i + 1) / 7) * 100}%`;
    btnPrev.style.visibility = i === 0 ? "hidden" : "visible";
    btnNext.textContent = i === 6 ? "記念日を発明する" : "つぎへ";
    qAnswer.focus();
  }

  function startQuestions() {
    document.getElementById("scene-intro").classList.add("hidden");
    document.getElementById("scene-questions").classList.remove("hidden");
    document.getElementById("scene-questions").classList.add("fade-in");
    showQuestion(0);
  }

  function nextQuestion() {
    answers[currentQ] = qAnswer.value;
    if (currentQ < 6) {
      currentQ++;
      showQuestion(currentQ);
    } else {
      invent();
    }
  }
  function prevQuestion() {
    answers[currentQ] = qAnswer.value;
    if (currentQ > 0) {
      currentQ--;
      showQuestion(currentQ);
    }
  }

  function invent() {
    document.getElementById("scene-questions").classList.add("hidden");
    document.getElementById("scene-inventing").classList.remove("hidden");
    document.getElementById("scene-inventing").classList.add("fade-in");

    const texts = [
      "あなたの言葉を、集めています…",
      "新しい記念日を、発明しています…",
      "あなたに処方する一輪を、選んでいます…"
    ];
    let i = 0;
    const inv = document.getElementById("inventing-text");
    const interval = setInterval(() => {
      i++;
      if (i < texts.length) inv.textContent = texts[i];
      else {
        clearInterval(interval);
        showResult();
      }
    }, 1300);
  }

  function showResult() {
    const name = inventName(answers);
    const date = inventDate();
    const flower = pickRandom(flowers);

    document.getElementById("result-name").textContent = name;
    document.getElementById("result-date").textContent = date;
    document.getElementById("result-flower-name").textContent = `処方される花 ─ ${flower.name}`;
    document.getElementById("result-flower-meaning").textContent = `「${flower.meaning}」`;

    // 背景に自分の記念日も降らせる
    addMemory(`${name} ${date}`, true);

    document.getElementById("scene-inventing").classList.add("hidden");
    document.getElementById("scene-result").classList.remove("hidden");
    document.getElementById("scene-result").classList.add("fade-in");
  }

  function restart() {
    currentQ = 0;
    answers.fill("");
    document.getElementById("scene-result").classList.add("hidden");
    document.getElementById("scene-intro").classList.remove("hidden");
    document.getElementById("scene-intro").classList.add("fade-in");
  }

  // ═══ 背景の「降り積もる記念日」演出 ═══
  const sampleMemories = [
    "自分を諦めなかった日  6月12日",
    "推しに出会って3年の日  4月2日",
    "ようやく許せた日  11月8日",
    "部屋を変えた日  3月21日",
    "初めて泣けた日  9月15日",
    "小さく誇れた日  7月4日",
    "ひそかに始めた日  1月9日",
    "まっすぐ進めた日  10月22日",
    "名もなき勝利の日  5月6日",
    "静かに変われた日  2月27日",
    "誰にも言わずに選んだ日  8月18日",
    "手放せた日記念日  12月3日"
  ];

  const sky = document.getElementById("memory-sky");

  function addMemory(text, highlight = false) {
    const el = document.createElement("div");
    el.className = "memory";
    el.textContent = text;
    el.style.left = Math.random() * 90 + "%";
    el.style.animationDuration = (Math.random() * 15 + 15) + "s";
    el.style.animationDelay = (Math.random() * 5) + "s";
    if (highlight) {
      el.style.color = "rgba(242, 195, 94, 0.6)";
      el.style.fontSize = "13px";
    }
    sky.appendChild(el);
    setTimeout(() => el.remove(), 35000);
  }

  // 起動時に降らせる
  sampleMemories.forEach((m, i) => {
    setTimeout(() => addMemory(m), i * 1500);
  });
  // 継続的に降らせる
  setInterval(() => {
    addMemory(pickRandom(sampleMemories));
  }, 3000);
</script>
</body>
</html>

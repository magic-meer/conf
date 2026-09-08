{
  programs.zen-browser.profiles.default.bookmarks = {
    force = true;
    settings = [
      {
        name = "AI";
        bookmarks = [
          {
            name = "ChatGPT";
            url = "https://chatgpt.com";
          }
          {
            name = "Gemini";
            url = "https://gemini.google.com";
          }
          {
            name = "Claude";
            url = "https://claude.ai";
          }
          {
            name = "DeepSeek";
            url = "https://chat.deepseek.com";
          }
          {
            name = "Qwen AI";
            url = "https://chat.qwen.ai";
          }
          {
            name = "Grok";
            url = "https://grok.com";
          }
        ];
      }
      {
        name = "Typing";
        bookmarks = [
          {
            name = "MonkeyType";
            url = "https://monkeytype.com";
          }
          {
            name = "TypeGrow";
            url = "https://typegrow.com/tools";
          }
        ];
      }
      {
        name = "Dev";
        bookmarks = [
          {
            name = "GitHub";
            url = "https://github.com";
          }
        ];
      }
      {
        name = "Social";
        bookmarks = [
          {
            name = "LinkedIn";
            url = "https://www.linkedin.com";
          }
          {
            name = "YouTube";
            url = "https://www.youtube.com";
          }
        ];
      }
    ];
  };
}
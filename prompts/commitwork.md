Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters. Just respond with the commit message formatted and ready to be saved. Don't wrap lines. Don't wrap lines in triple quotes. Don't use emojis.

Start the title with the ticket number in the form "RD-xxxxx". You can find the ticket number in the start of the current branch name. For example: for branch name `origin/RD-12345-mod1-foobar`, the ticket is `RD-12345`.

You can find the module by using the first word after the ticket number on the branch name. For example: for branch name `origin/RD-12345-mod1-foobar`, the message would be `RD-12345 - feat(mod1): Add new feature`.

Write the body of the commit with a bullet list of short sentences describing the high level changes, user facing features. Not too much implementation details. Don't use concepts like "enhance" or "improve". Don't describe what was done, but the effects of what was done.

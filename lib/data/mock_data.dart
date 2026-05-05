import '../models/exam.dart';
import 'additional_questions.dart';
import 'scraped_questions.dart';


final List<Exam> mockExams = [
  Exam(
    id: 'exam_domain_1',
    title: 'Domain 1: Agentic Architecture & Orchestration',
    description: 'Test your knowledge on orchestrating LLM agents, loops, and routing.',
    questions: [
      Question(
        id: 'q1_1',
        text: 'You are designing an autonomous support agent using Claude. The agent must resolve user issues by reasoning through steps and determining which tool to call next. Which architectural pattern best fits this requirement?',
        options: [
          'A simple prompt chain with fixed steps.',
          'A ReAct (Reasoning and Acting) loop where Claude iteratively thinks, acts, and observes tool outputs.',
          'A Map-Reduce architecture that processes multiple documents in parallel.',
          'A single zero-shot prompt with all possible answers hardcoded.'
        ],
        correctAnswerIndex: 1,
        explanation: 'The ReAct pattern allows an agent to reason about the current state, decide on an action (tool call), observe the output, and iteratively progress toward a resolution.',
      ),
      Question(
        id: 'q1_2',
        text: 'When orchestrating multiple specialized AI agents, you implement a "Router" pattern. What is the primary function of the routing agent?',
        options: [
          'To load-balance API requests across multiple server endpoints to prevent rate limits.',
          'To map human user intent and delegate the task to the most appropriate domain-specific sub-agent.',
          'To automatically connect to external databases without using the Model Context Protocol (MCP).',
          'To generate final source code independently.'
        ],
        correctAnswerIndex: 1,
        explanation: 'In multi-agent orchestration, a router analyzes the incoming request and dispatches it to specialized sub-agents best suited for the specific task.',
      ),
      Question(
        id: 'q1_3',
        text: 'To avoid infinite loops in an agentic workflow, what is an essential constraint to implement?',
        options: [
          'Set the temperature to 0.0.',
          'Enforce a strict maximum iteration / max steps limit in the orchestration runtime.',
          'Ensure the agent never uses tools.',
          'Provide the prompt exclusively in XML tags.'
        ],
        correctAnswerIndex: 1,
        explanation: 'An agentic loop should always have a maximum iteration limit within the orchestration code to prevent it from looping indefinitely if it gets confused or unable to complete a task.',
      ),
      Question(
        id: 'q1_4',
        text: 'What is the "Plan-and-Execute" agentic pattern?',
        options: [
          'An agent creates a long-term goal structure first, then sequentially executes and validates each micro-step towards the goal.',
          'The prompt generation phase executed over cloud VMs.',
          'An architecture where tools execute first before any prompt is generated.',
          'A way to pre-cache prompts for faster execution.'
        ],
        correctAnswerIndex: 0,
        explanation: 'In Plan-and-Execute workflows, Claude is first tasked with generating a step-by-step strategy. A subsequent agent (or loop) executes those steps sequentially.',
      ),
      Question(
        id: 'q1_5',
        text: 'When using an Evaluator-Optimizer loop, what role does the Evaluator play?',
        options: [
          'It compiles the code to machine language.',
          'It critiques the output of the Optimizer and provides feedback to correct structural or logical errors until criteria are met.',
          'It ranks the available models by cost.',
          'It reduces the token size of the user prompt.'
        ],
        correctAnswerIndex: 1,
        explanation: 'The Evaluator agent grades or reviews the generated output against a rubric, returning feedback to the Generator/Optimizer until the output passes the criteria.',
      ),
      Question(
        id: 'q1_6',
        text: 'You want to build a system that analyzes an article and returns 5 different summaries emphasizing different perspectives. Which pattern is most efficient?',
        options: [
          'A ReAct loop running in sequence 5 times.',
          'Parallel execution using a Map-style aggregation, running 5 independent prompts concurrently.',
          'A single long conversation taking hours to answer.',
          'A Router agent analyzing the text 5 times.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Running independent parallel prompts (Map) is vastly faster than running a sequential loop when tasks do not depend on one another.',
      ),
      Question(
        id: 'q1_7',
        text: 'How should memory be managed in a multi-agent application?',
        options: [
          'Pass the entire chat history unedited to every single sub-agent.',
          'Maintain a shared scratchpad or scoped state that contains only the relevant synthesized facts for the current agent.',
          'Keep memory solely within the Anthropic server.',
          'Agents do not require memory because of prompt caching.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Passing entire histories bloats context window and increases cost. A synthesized short-term memory (scratchpad) specific to what the sub-agent needs is far more robust.',
      ),
      Question(
        id: 'q1_8',
        text: 'If an agent tool call times out in production, how should the application layer handle it?',
        options: [
          'Crash silently.',
          'Return a system message explaining the timeout to Claude, allowing it to decide if it should retry or inform the human.',
          'Assume success and proceed without tool data.',
          'Disconnect the model\'s API key.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Error handling in an agentic workflow involves sending errors (including timeouts) back as the tool\'s result, enabling Claude to adjust its strategy logically.',
      ),
      Question(
        id: 'q1_9',
        text: 'Why would an architect choose a Human-in-the-Loop workflow over a fully autonomous ReAct agent?',
        options: [
          'To increase the speed of the code execution.',
          'To ensure safety, override capability, and validation on high-stakes actions (e.g., executing DB mutations).',
          'To decrease API pricing.',
          'To force the agent to use XML tags.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Human-in-the-loop provides a necessary checkpoint for safety when the agent\'s actions have permanent or high-stakes consequences.',
      ),
      Question(
        id: 'q1_10',
        text: 'When choosing between a single large agent with many tools vs a multi-agent router architecture, what is a key indicator to use multi-agent?',
        options: [
          'When the system only requires 1 or 2 straightforward API calls.',
          'When the tools require diverse, conflicting personas, or there are so many tools that the description exceeds the context limit.',
          'When prompt caching is fundamentally disabled.',
          'When using a lower-tier model.'
        ],
        correctAnswerIndex: 1,
        explanation: 'A router with specialized sub-agents is ideal when tools or instructions conflict, or when combining them in a single prompt causes the model to lose focus.',
      ),
      Question(
        id: 'q1_11',
        text: 'Which of the following are valid patterns for agentic architectures? (Select all that apply)',
        options: [
          'Routing (Router Pattern)',
          'Evaluator-Optimizer Loop',
          'Human-in-the-Loop',
          'Blockchain-verified execution',
          'Map-Reduce / Parallelization'
        ],
        correctAnswers: [0, 1, 2, 4],
        explanation: 'Routing, Evaluator-Optimizer, Human-in-the-Loop, and Parallelization are all established architectural patterns for agentic workflows. Blockchain verification is not a standard agentic architecture pattern.',
      ),
      Question(
        id: 'q1_12',
        text: 'According to Anthropic best practices, when is a Router Pattern preferred over a single large ReAct agent?',
        options: [
          'When prompt caching is completely disabled.',
          'When multiple tools have conflicting instructions, or combining all schemas exceeds context limits.',
          'When generating images only.',
          'When the user requests extremely long Python scripts.'
        ],
        correctAnswerIndex: 1,
        explanation: 'A Router Agent acts as a dispatch mechanism, routing specialized tasks to sub-agents. It is ideal when an agent needs to use multiple tools that have competing personas or confusing instructions when combined.',
      ),
      Question(
        id: 'q1_13',
        text: 'In a ReAct loop, the agent repeatedly calls the same tool with identical parameters, creating an infinite loop. What is the standard structural fix?',
        options: [
          'Increase the temperature to 1.0 to increase token variance.',
          'Implement a maximum iteration cap in the orchestration code to physically halt the loop.',
          'Provide negative prompts instructing Claude not to loop.',
          'Decrease the context window size.',
        ],
        correctAnswerIndex: 1,
        explanation: 'An orchestrator must always wrap agentic loops with a max_iterations or max_steps variable. LLMs can occasionally get stuck, and structural caps prevent runaway compute.',
      ),
      Question(
        id: 'q1_14',
        text: 'When designing a multi-agent system, a developer is integrating an MCP server to access a REST API. The server returns a 401 Unauthorized error. How should the architect design the agentic resolution?',
        options: [
          'Return the exact error message and code back to Claude as the tool outcome.',
          'Terminate the ReAct loop to prevent infinite token usage.',
          'Switch to a 0.0 temperature model and retry.',
          'Bypass the MCP protocol and write a custom adapter.',
        ],
        correctAnswerIndex: 0,
        explanation: 'In Model Context Protocol integration, passing error states directly back to the LLM allows it to reason over the failure and correct its tool invocation or notify the user accurately.',
      ),
      ...domain1AdditionalQuestions,
      ...scrapedDomain1Questions,
    ],

  ),
  Exam(
    id: 'exam_domain_2',
    title: 'Domain 2: Claude Code Configuration & Workflows',
    description: 'Assess configuration, standard operations, and CLI workflows.',
    questions: [
      Question(
        id: 'q2_1',
        text: 'You are using Claude Code within your command line to refactor a large project. How does Claude Code preserve safety before executing potentially destructive bash commands?',
        options: [
          'It requires you to establish a VPN connection.',
          'It pauses and waits for user approval (Y/N/Enter) before running commands that modify state or execute unknown scripts.',
          'It executes them silently but creates an automatic git commit to rollback if needed.',
          'It refuses to run any bash commands whatsoever.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Claude Code enforces a human-in-the-loop mechanism and explicitly asks for approval prior to executing potentially unsafe CLI commands.',
      ),
      Question(
        id: 'q2_2',
        text: 'In Claude Code, you can use built-in tools like `grep_search` or `glob_search`. Why are these specific tools preferred over instructing Claude to use generic shell tools like `find` and `grep` directly?',
        options: [
          'They parse output into a structured JSON/XML format that Claude natively interprets better without hallucinating.',
          'They are faster because they run on Anthropic servers.',
          'You cannot use bash commands at all in Claude Code.',
          'They bypass local file system permissions.'
        ],
        correctAnswerIndex: 0,
        explanation: 'Claude Code provides tightly-integrated primitive tools that format the search results uniformly, allowing the model to parse context accurately and reliably without relying on varied bash outputs.',
      ),
      Question(
        id: 'q2_3',
        text: 'How can you prevent Claude Code from analyzing or modifying specific directories, such as `/node_modules` or secret keys?',
        options: [
          'Using a `.claudeignore` file or ensuring it respects `.gitignore`.',
          'Placing the folders in a zip file.',
          'Adding a comment at the top of the file saying "Do not read".',
          'Turning off the computer\'s Wi-Fi.'
        ],
        correctAnswerIndex: 0,
        explanation: 'Similar to git, a `.claudeignore` file or standard `.gitignore` prevents Claude Code from seeing or messing with internal build directories or secure keys.',
      ),
      Question(
        id: 'q2_4',
        text: 'When resuming a previous session in Claude Code, what happens to the AI\'s context?',
        options: [
          'It resets entirely; Claude starts fresh.',
          'It relies on the cached history of the conversation, restoring context so it can continue where it left off.',
          'It requires the user to manually re-type everything.',
          'It deletes the files it was working on.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Resuming an interactive session restores the context window allowing the agent to seamlessly pick up its previous logic.',
      ),
      Question(
        id: 'q2_5',
        text: 'If Claude Code generates a command that creates an infinite loop in your bash terminal, how should you respond?',
        options: [
          'Wait 24 hours.',
          'Use the tool cancellation/termination interrupt feature (Ctrl+C on the CLI side) to kill the background command.',
          'Close the Anthropic account.',
          'Unplug the hard drive.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Users must retain shell-level override capabilities like standard Ctrl+C to stop rogue processes spawned by the model.',
      ),
      Question(
        id: 'q2_6',
        text: 'What environment variable is typically required to authenticate the Claude Code CLI tool locally?',
        options: [
          'AWS_SECRET_ACCESS_KEY',
          'ANTHROPIC_API_KEY',
          'GCP_PROJECT_ID',
          'CLAUDE_PASSWORD'
        ],
        correctAnswerIndex: 1,
        explanation: 'The ANTHROPIC_API_KEY environment variable is the standard authentication requirement for Claude CLI environments.',
      ),
      Question(
        id: 'q2_7',
        text: 'What is the primary benefit of granting Claude Code native file editing privileges instead of relying entirely on standard bash `sed` or `cat` injection?',
        options: [
          'Sed uses too much RAM.',
          'Native file editing tools (like replace_file_content) handle multi-line replacement and precise positional targeting much more accurately than piping strings via Bash.',
          'Native edits don\'t show up in git commits.',
          'File editing through bash triggers virus scanners.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Complex multi-line replacements are notoriously brittle with sed or echo, whereas native editing abstractions map directly to the file DOM reliably.',
      ),
      Question(
        id: 'q2_8',
        text: 'Within an agentic coding environment, when should Claude run a `build` or `compile` command?',
        options: [
          'Only after the user signs a waiver.',
          'Whenever the codebase undergoes a significant edit and the agent needs to verify that the syntax compiles correctly (feedback loop).',
          'Before it writes any code.',
          'At exactly 12:00 PM.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Running a build command serves as a critical verification step within the feedback loop, ensuring changes did not break the project.',
      ),
      Question(
        id: 'q2_9',
        text: 'How can you establish customized, persistent project guidelines that Claude Code automatically follows without having to manually supply the prompt every time?',
        options: [
          'Emailing Anthropic Support.',
          'Creating a CLAUDE.md file at the root of the project with architecture schemas, design guidelines, and code conventions.',
          'Adding a sticky note to the desktop.',
          'Changing the `.bashrc` file.'
        ],
        correctAnswerIndex: 1,
        explanation: 'The CLAUDE.md file serves as the definitive, project-specific instruction manual. Claude Code automatically ingests this file to understand repo-specific rules, architecture patterns, and custom workflows before taking action.'
      ),
      Question(
        id: 'q2_11',
        text: 'A workflow requires code refactoring with native terminal command execution. Why use Claude Code instead of a bare agent with shell access?',
        options: [
          'Claude Code integrates a strict human-in-the-loop approval mechanism for destructive bash commands automatically.',
          'Claude Code does not use the Anthropic API, making it free.',
          'Claude Code runs 10x faster by bypassing the internet.',
          'Claude Code automatically ignores all syntax errors.',
        ],
        correctAnswerIndex: 0,
        explanation: 'Safety is paramount. Claude Code includes human approval checks for destructive commands or running arbitrary scripts, preventing unintended file system damage.',
      ),
      Question(
        id: 'q2_12',
        text: 'When configuring Claude Code for CI/CD pipelines, which combination of security measures is most appropriate?',
        options: [
          'Use the root API key and approve all commands automatically.',
          'Use a tightly scoped API key, pre-approved deterministic workflows, and an ephemeral sandboxed container.',
          'Run Claude Code directly on the production server.',
          'Disable all tool calls and use only text output.',
        ],
        correctAnswerIndex: 1,
        explanation: 'In headless CI/CD environments, you cannot have a human intercepting commands. Scoped credentials, ephemeral runners, and deterministic flows prevent rogue deployment commands.',
      ),
      Question(
        id: 'q2_10',
        text: 'When configuring Claude Code for CI/CD integration pipelines, what is a crucial security consideration regarding tool approval?',
        options: [
          'Setting `-y` or approval overrides completely disabled so a human must approve every test.',
          'Delegating deployment credentials to the model.',
          'Using a tightly scoped API key, configuring pre-approved deterministic workflows, and running the agent in a sandboxed, ephemeral container.',
          'Pushing code without running unit tests.'
        ],
        correctAnswerIndex: 2,
        explanation: 'In CI/CD (which is inherently headless), you cannot have a human intercepting commands. Therefore, you must use heavily scoped credentials, ephemeral runner environments, and strict deterministic flows to prevent rogue deployment commands.'
      ),
      ...domain2AdditionalQuestions,
      ...scrapedDomain2Questions,
    ],

  ),
  Exam(
    id: 'exam_domain_3',
    title: 'Domain 3: Prompt Engineering & Structured Output',
    description: 'Techniques for clear instructions, XML tagging, and structural constraints.',
    questions: [
      Question(
        id: 'q3_1',
        text: 'Anthropic recommends using specific formatting structures to separate distinct parts of a prompt and help Claude organize its context. What is the recommended formatting structure?',
        options: [
          'JSON objects for all text.',
          'Markdown headers strictly without any tags.',
          'XML-like tags (e.g., <document>, <instructions>).',
          'Comma-separated values (CSV).'
        ],
        correctAnswerIndex: 2,
        explanation: 'Claude is heavily trained to recognize and prioritize information enclosed in XML-like tags, making it the most effective way to separate context, variables, and instructions.',
      ),
      Question(
        id: 'q3_2',
        text: 'You need Claude to extract entities from an unstructured document and return them strictly in JSON format. What is the most effective way to guarantee a valid JSON response without conversational filler?',
        options: [
          'Ask nicely: "Please return only JSON, no other text".',
          'Use the "Tool Calling" capability passing a JSON schema, or pre-fill the Assistant\'s response with a "{" character.',
          'Set temperature to 1.0 to ensure strictness.',
          'Provide a long system prompt with negative constraints but no examples.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Using Tool Calling (where Claude passes arguments corresponding to a given schema) or pre-filling the assistant\'s message with the opening bracket `{` ensures the response is pure JSON.',
      ),
      Question(
        id: 'q3_3',
        text: 'Which practice is highly discouraged when prompting Claude?',
        options: [
          'Providing few-shot examples.',
          'Assigning Claude a persona or role.',
          '"Negative prompting" as the sole instruction (telling Claude only what NOT to do without telling it what to do).',
          'Putting the most important instructions at the very end of the prompt.'
        ],
        correctAnswerIndex: 2,
        explanation: 'Negative prompting alone is often ineffective. It is better to provide explicit instructions detailing exactly what the model SHOULD do and what format it SHOULD use.',
      ),
      Question(
        id: 'q3_4',
        text: 'What does "Chain of Thought" (CoT) prompting achieve?',
        options: [
          'It links multiple users together in a single API call.',
          'It forces the model to articulate its reasoning step-by-step prior to outputting the final answer, significantly reducing logical errors.',
          'It connects the API to a blockchain.',
          'It compresses the prompt size by 50%.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Creating a <thinking> block for CoT dramatically improves the model\'s ability to solve complex logical problems before committing to a final answer.',
      ),
      Question(
        id: 'q3_5',
        text: 'When providing a massive amount of context (e.g., 50 pages of logs) and asking Claude a question about it, where should the question be placed?',
        options: [
          'At the very beginning, before the logs.',
          'Randomly inside the logs.',
          'At the very end of the prompt, after the logs.',
          'In a separate API call entirely.'
        ],
        correctAnswerIndex: 2,
        explanation: 'Due to "attention" mechanics, Claude adheres to instructions placed at the bottom of a massive context block far better than instructions placed at the top.',
      ),
      Question(
        id: 'q3_6',
        text: 'What is "Few-Shot" prompting?',
        options: [
          'Giving the model very little time to compute the answer.',
          'Providing a few examples of desired input and output to calibrate the model\'s style and format.',
          'Taking multiple screenshots of the prompt.',
          'Running the prompt through a smaller model first.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Few-shot prompting provides high-quality examples inside the prompt to guide the model\'s tone, formatting, and analytical style.',
      ),
      Question(
        id: 'q3_7',
        text: 'For optimal results, how should you structure the System Prompt?',
        options: [
          'Keep it blank to save tokens.',
          'Use it exclusively to define the persona, general behavioral constraints, and static rules that apply globally.',
          'Put all user conversation history in it.',
          'Pass the tool schema descriptions inside it.'
        ],
        correctAnswerIndex: 1,
        explanation: 'The system prompt establishes the overarching operational boundaries and persona. Dynamic, turn-specific context belongs in the user prompt.',
      ),
      Question(
        id: 'q3_8',
        text: 'If Claude frequently outputs "Here is the JSON you requested:" before outputting the actual JSON, what is the best way to stop this?',
        options: [
          'Threaten the model with failure.',
          'Set a negative penalty for the word "Here".',
          'Use the Assistant Prefill technique by providing `{"` as the start of the assistant\'s message.',
          'Parse it with a regex manually.'
        ],
        correctAnswerIndex: 2,
        explanation: 'Assistant prefilling gives the model the start of its own output, totally bypassing any conversational filler and forcing it straight into the desired structure.',
      ),
      Question(
        id: 'q3_9',
        text: 'When providing code examples to Claude in a system prompt to demonstrate a formatting structure, what is the best practice for encapsulation?',
        options: [
          'Put them at the very end of the prompt without tags.',
          'Wrap them in XML tags like <example> to explicitly separate them from the core instructions.',
          'Use triple quotes instead of standard markdown.',
          'In-line the code directly within conversational text.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Anthropic heavily recommends wrapping examples and distinct structural elements in XML tags to prevent context bleed and improve reasoning isolation.'
      ),
      Question(
        id: 'q3_11',
        text: 'You are submitting 100,000 tokens of codebase context to Claude. For maximum accuracy, where should the primary instruction/question be placed?',
        options: [
          'At the very end of the prompt, after all the context.',
          'At the very beginning, before any context.',
          'Randomly interleaved throughout the codebase.',
          'In a completely separate API call.',
        ],
        correctAnswerIndex: 0,
        explanation: 'Due to Recency Bias in LLMs, placing primary action items and queries at the very bottom of an overloaded context window yields significantly higher retrieval accuracy.',
      ),
      Question(
        id: 'q3_12',
        text: 'To dramatically reduce hallucinations when querying a long document, which prompting technique is most effective?',
        options: [
          'Ask the model to format the answer in JSON.',
          'Instruct the model to extract verbatim quotes inside <quotes> tags before synthesizing the answer.',
          'Disable Prompt Caching.',
          'Increase Top-P and Temperature.',
        ],
        correctAnswerIndex: 1,
        explanation: 'Quote extraction (asking the model to cite its sources verbatim in an XML block before answering) forces grounding and eliminates over 90% of hallucinations.',
      ),
      Question(
        id: 'q3_13',
        text: 'To force Claude to strictly output JSON for an application without any conversational filler, what technique is most effective?',
        options: [
          'Use Assistant Prefill by seeding the opening { character into the beginning of the Assistant message block.',
          'Set temperature to 0.5.',
          'Write "Please do not add any other words."',
          'Write exclusively negative prompts.',
        ],
        correctAnswerIndex: 0,
        explanation: 'Assistant Prefilling bypasses the model\'s conversational tendencies completely by forcing the generation to continue from the structural start block.',
      ),
      Question(
        id: 'q3_10',
        text: 'You are utilizing Claude for sentiment analysis. Which technique effectively forces Claude to respond with only the classification and no conversational filler?',
        options: [
          'Adding "Do not say anything else" three times.',
          'Prefilling the Assistant\'s message payload with the desired opening character, such as a curly brace `{` or <tag>.',
          'Using a temperature of 1.0.',
          'Lowering the context window globally.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Assistant prefilling is a native Claude feature that bypasses conversational filler by forcing the model to instantly continue generation from the structural start block.'
      ),
      ...domain3AdditionalQuestions,
      ...scrapedDomain3Questions,
    ],

  ),
  Exam(
    id: 'exam_domain_4',
    title: 'Domain 4: Tool Design & MCP Integration',
    description: 'Model Context Protocol and Tool calling implementation details.',
    questions: [
      Question(
        id: 'q4_1',
        text: 'What is the primary purpose of the Model Context Protocol (MCP)?',
        options: [
          'To format training data for Anthropic.',
          'To provide a standardized open protocol enabling LLMs to securely connect with external tools, APIs, and file systems independently of the UI client.',
          'To compress context windows to save token cost.',
          'A networking layer replacing HTTPS for Claude API calls.'
        ],
        correctAnswerIndex: 1,
        explanation: 'MCP is an open standard introduced by Anthropic that standardizes how AI models securely retrieve context and interact with local and remote resources, tools, and databases.',
      ),
      Question(
        id: 'q4_2',
        text: 'When defining a tool schema for Claude, why is providing detailed `description` fields for both the tool and its parameters critical?',
        options: [
          'It is required by JSON syntax.',
          'Claude relies heavily on the natural language description to determine WHEN to use the tool and HOW to populate its parameters properly.',
          'It reduces the cost of the API call.',
          'It allows developers to read the code more easily, but Claude ignores them.'
        ],
        correctAnswerIndex: 1,
        explanation: 'The descriptions in the tool schema serve as the prompt for the tool. Claude evaluates these descriptions using semantic reasoning to decide if the tool solves the user\'s task.',
      ),
      Question(
        id: 'q4_3',
        text: 'If a tool call fails or returns an error (e.g., API 404), what is the best practice for handling this in an agentic workflow?',
        options: [
          'Crash the orchestrator and tell the user.',
          'Return the error message as the tool result back to Claude, so the model can read the error and try a different approach or fix the parameters.',
          'Hide the error and return a success message so Claude doesn\'t get confused.',
          'Immediately retry the exact same tool call 10 times in a row.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Passing the error text back to Claude as the tool outcome allows Claude\'s reasoning capabilities to deduce what went wrong and formulate a correction.',
      ),
      Question(
        id: 'q4_4',
        text: 'In an MCP architecture, which component executes the actual tool logic?',
        options: [
          'The Anthropic inference server.',
          'The LLM directly via code interpreter.',
          'The MCP Server running locally or remotely, acting upon requests sent by the MCP Client.',
          'The user\'s web browser.'
        ],
        correctAnswerIndex: 2,
        explanation: 'The MCP architecture places the execution burden on the MCP Server. The LLM simply issues the request through the MCP Client.',
      ),
      Question(
        id: 'q4_5',
        text: 'When designing a tool that searches a database, it is best to:',
        options: [
          'Return all 10,000 rows so Claude has complete context.',
          'Implement pagination or limit parameters to return a manageable chunk of results (e.g., top 10).',
          'Encode the database into a JPEG.',
          'Only return boolean true/false values.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Returning massive payloads can overflow the context window and cause hallucinations. Tools should return concise, bounded data sets.',
      ),
      Question(
        id: 'q4_6',
        text: 'What happens when you define a parameter as `required` in a JSON schema for a Claude tool call?',
        options: [
          'Claude will hallucinate data if it doesn\'t know the parameter.',
          'Claude will refuse to execute the tool unless it is confident it deduced the requirement from the prompt context, or it will ask the user for clarification.',
          'The tool automatically infers the data types.',
          'It crashes the API.'
        ],
        correctAnswerIndex: 1,
        explanation: 'If a parameter is required but missing from context, an aligned model will pause the tool execution and ask the user to provide the missing required information.',
      ),
      Question(
        id: 'q4_7',
        text: 'To avoid "tool hallucination" (where the LLM calls a tool that doesn\'t exist), you should:',
        options: [
          'Provide extremely strict descriptions and ensure the list of tools passed is accurate and tightly scoped.',
          'Set the temperature to 2.0.',
          'Never use JSON.',
          'Keep tool names as single letters.'
        ],
        correctAnswerIndex: 0,
        explanation: 'Reducing tool choices and using descriptive, unambiguous tool names prevents the model from predicting invalid tools.',
      ),
      Question(
        id: 'q4_8',
        text: 'Can an MCP Server enforce authentication or role-based access control?',
        options: [
          'No, the LLM bypasses security automatically.',
          'Yes, the MCP server handles local AuthN/AuthZ entirely on its own side before allowing the payload to execute.',
          'Only if the Anthropic API is given the root password.',
          'Yes, but only via OAuth2.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Because the execution happens on the host\'s MCP Server, all local system security, RBAC, and permissions remain completely native to that environment.',
      ),
      Question(
        id: 'q4_9',
        text: 'In the Model Context Protocol (MCP), what is the primary role of the MCP Client (e.g., Claude Desktop)?',
        options: [
          'To maintain connections with multiple MCP Servers, aggregate local resources, and route context safely to the LLM.',
          'To execute python scripts locally on behalf of the user.',
          'To persistently store vector embeddings.',
          'To directly execute remote web search results.'
        ],
        correctAnswerIndex: 0,
        explanation: 'The MCP Client acts as the critical bridge, managing standard protocol connections to localized Host Servers and ferrying context to the Model securely.'
      ),
      Question(
        id: 'q4_10',
        text: 'When defining a JSON schema for a Claude Tool, what attribute is strictly necessary if a parameter must always be provided by the model?',
        options: [
          'A `mustBeFilled` boolean flag on the property.',
          'The `required` array in the JSON schema containing the property name.',
          'Setting the type to `strict_string`.',
          'Nothing, Claude intelligently infers required parameters.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Claude adheres to strict JSON schema definitions. You must explicitly list mandatory properties in the schemas `required` array to enforce them before tool execution.'
      ),
      Question(
        id: 'q4_11',
        text: 'What are the main benefits of using the Model Context Protocol (MCP)? (Select all that apply)',
        options: [
          'It provides a unified open standard for tools and context.',
          'It completely eliminates API hallucination.',
          'It allows Claude Desktop and other clients to connect to diverse local resources securely without custom integrations.',
          'It increases the maximum token limit by 10x.'
        ],
        correctAnswers: [0, 2],
        explanation: 'MCP provides a unified open standard to securely connect models to data sources and tools without requiring unique integration code for each source. It does not magically increase context limits or eliminate all hallucinations natively.'
      ),
      Question(
        id: 'q4_12',
        text: 'In the MCP architecture, the server returns a JSON parse error after a tool call. How should the agent handle this?',
        options: [
          'Return the exact error message and code back to Claude as the tool outcome so it can reason over the failure.',
          'Terminate the ReAct loop immediately to prevent infinite token usage.',
          'Switch to a temperature of 0.0 and automatically retry.',
          'Bypass the MCP protocol and write a custom raw HTTP adapter.',
        ],
        correctAnswerIndex: 0,
        explanation: 'Passing error states directly back to the LLM as the tool result allows it to reason over the failure and correct its tool invocation parameters or notify the user accurately.',
      ),
      Question(
        id: 'q4_13',
        text: 'When creating an MCP tool schema for a Postgres database, how does Claude decide when to invoke the tool?',
        options: [
          'Based solely on the tool\'s programmatic function name.',
          'By reasoning over the detailed natural language "description" provided for the tool and its parameters.',
          'By downloading and parsing the tool\'s source code.',
          'By matching the user\'s query to the exact tool name string.',
        ],
        correctAnswerIndex: 1,
        explanation: 'Claude relies entirely on the natural language semantic description attached to the schema. A clear, detailed description is critical for reliable tool selection.',
      ),
      ...domain4AdditionalQuestions,
      ...scrapedDomain4Questions,
    ],

  ),
  Exam(
    id: 'exam_domain_5',
    title: 'Domain 5: Context Management & Reliability',
    description: 'Techniques for managing context windows, RAG, and reducing hallucinations.',
    questions: [
      Question(
        id: 'q5_1',
        text: 'When dealing with a massive codebase that exceeds Claude\'s context window, what architectural pattern is necessary?',
        options: [
          'Zero-Shot Prompting.',
          'Retrieval-Augmented Generation (RAG) to embed and retrieve only the chunks mathematically relevant to the query.',
          'Prompt caching.',
          'Decreasing the temperature to 0.'
        ],
        correctAnswerIndex: 1,
        explanation: 'RAG allows an application to fetch only the statistically relevant data chunks to fit inside the context window, preventing overflow.',
      ),
      Question(
        id: 'q5_2',
        text: 'Anthropic\'s Prompt Caching allows you to drastically reduce costs and latency. In what scenario is Prompt Caching most effective?',
        options: [
          'When sending a rapid succession of completely unique, non-overlapping 5-token prompts.',
          'When you have a large static system prompt or lengthy document provided repeatedly at the start of a conversational session.',
          'When streaming responses.',
          'When generating images.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Prompt caching works by caching prefixes of prompts. It provides massive savings when a large amount of static context (like a thick system prompt, book, or codebase) is prepended to multiple iterative queries.',
      ),
      Question(
        id: 'q5_3',
        text: 'What is a highly effective way to prevent Claude from hallucinating when asked questions about a provided context document?',
        options: [
          'Ask Claude to output its answer in base64.',
          'Tell Claude to "Think aloud" by extracting relevant quotes from the document inside <quotes> tags before formulating its final answer.',
          'Increase the Top-P value to 1.0.',
          'Tell Claude it will be penalized if it hallucinates.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Forcing the model to cite specific evidence verbatim within <quotes> tags significantly anchors the model to the provided text and mitigates hallucinations.',
      ),
      Question(
        id: 'q5_4',
        text: 'When chunking text for a RAG system, what does "overlap" refer to?',
        options: [
          'Including the last sentence of Chunk 1 as the first sentence of Chunk 2 to preserve semantic continuity across boundaries.',
          'Double-billing the API cost.',
          'Stacking the text visually in the UI.',
          'Sending the same prompt twice simultaneously.'
        ],
        correctAnswerIndex: 0,
        explanation: 'Overlap prevents critical context from being split awkwardly in the middle of a sentence or concept, ensuring the embedding model captures complete thoughts.',
      ),
      Question(
        id: 'q5_5',
        text: 'If a user prompt is contradictory to the strict rules in the System prompt, how does a highly aligned model usually behave?',
        options: [
          'It overrides the system prompt and obeys the user.',
          'It crashes.',
          'It adheres to the bounds established internally by the System prompt, politely refusing the contradictory user request.',
          'It hallucinates a middle ground.'
        ],
        correctAnswerIndex: 2,
        explanation: 'The system prompt acts as a strict sandbox. The model is trained to prioritize these systemic constraints over adversarial or conflicting user inputs.',
      ),
      Question(
        id: 'q5_6',
        text: 'Decreasing the "Temperature" parameter to 0.0 is best used for:',
        options: [
          'Generating highly creative poetry.',
          'Ensuring highly deterministic and reproducible outputs for data extraction, coding constraints, or factual reasoning.',
          'Speeding up the inference time.',
          'Blowing past token generation limits.'
        ],
        correctAnswerIndex: 1,
        explanation: 'A temperature of 0 minimizes randomness, which forces the model to choose the most likely next token every time, improving reliability in analytical tasks.',
      ),
      Question(
        id: 'q5_7',
        text: 'What happens to "attention" when the context window is near maximum capacity with irrelevant text?',
        options: [
          'It ignores the prompt entirely.',
          'The signal-to-noise ratio drops, often causing the model to miss subtle details buried in the middle of the text (Lost in the Middle phenomenon).',
          'It generates only images instead.',
          'It automatically deletes older messages.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Even with massive context windows, injecting huge amounts of irrelevant text reduces the model\'s focus, which degrades reasoning accuracy on specific details.',
      ),
      Question(
        id: 'q5_8',
        text: 'When chaining multiple prompts to handle a complex task, what is a key benefit for reliability?',
        options: [
          'Prompt chains increase the token cost artificially.',
          'It isolates specific context, reducing cognitive overload and hallucinations, ensuring each sub-task is handled with intense focus.',
          'It bypasses rate limits.',
          'It forces the model to ignore user inputs.'
        ],
        correctAnswerIndex: 1,
        explanation: 'A complex task broken into smaller prompt chains allows the model to analyze isolated sub-problems without being distracted by adjacent, irrelevant context.',
      ),
      Question(
        id: 'q5_9',
        text: 'What is a "semantic caching" layer primarily used for in Agentic Context Management architectures?',
        options: [
          'Caching the Weights of the AI Model in system RAM.',
          'Skipping the LLM call entirely by serving a previously stored response to an identical or highly similar user request.',
          'Saving all API keys locally in an encrypted vault.',
          'Prefetching vector database entries before they are explicitly requested.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Semantic caching evaluates the embedding vector of an incoming query and immediately serves a cached response if a high-similarity match is found, eliminating API costs and latency entirely.'
      ),
      Question(
        id: 'q5_10',
        text: 'Why does Anthropic highly recommend placing specific, dynamic context (such as the actual user query) at the absolute bottom of a large context prompt?',
        options: [
          'Because the Claude API string parser executes in reverse.',
          'To capitalize on "Recency Bias", ensuring the model heavily weighs the immediate instruction rather than getting misdirected by massive background context.',
          'To avoid automated prompt injection attacks.',
          'It is a strict requirement for Prefix Prompt Caching to function efficiently.'
        ],
        correctAnswerIndex: 1,
        explanation: 'LLMs exhibit "Recency Bias", meaning they naturally focus on the tokens nearest the end of the generator block. Critical action items should never be buried at the top.'
      ),
      Question(
        id: 'q5_11',
        text: 'A RAG system is suffering from "Lost in the Middle" errors. How can this be mitigated?',
        options: [
          'Decrease the context chunk size and strictly limit the number of retrieved chunks (e.g., top 5) passed to the prompt.',
          'Pass the entire database in one prompt to give Claude maximum information.',
          'Translate the chunks into a different language before retrieval.',
          'Run the RAG pipeline on a local device to reduce latency.',
        ],
        correctAnswerIndex: 0,
        explanation: 'Overloading the context window with low-relevance chunks dilutes attention and causes the model to miss details in the middle. Limit retrieval to only the highest-scored K chunks.',
      ),
      Question(
        id: 'q5_12',
        text: 'To maximize cost savings with Prompt Caching, how should you structure the prompt?',
        options: [
          'Put dynamic user inputs at the top and static system instructions at the bottom.',
          'Put heavy static text (rules, examples, large documents) at the top of the prompt and dynamic, frequently changing instructions at the bottom.',
          'Do not use XML tags, as they prevent caching.',
          'Cache only the smallest possible chunks for granularity.',
        ],
        correctAnswerIndex: 1,
        explanation: 'Prompt caching leverages prefix caching. Static chunks must appear at the absolute beginning of the prompt to hit the cache successfully across multiple requests.',
      ),
      Question(
        id: 'q5_13',
        text: 'What is a "semantic caching" layer primarily used for in Agentic Context Management architectures?',
        options: [
          'Caching the weights of the AI model in system RAM to speed up inference.',
          'Skipping the LLM call entirely by serving a previously stored response to an identical or highly similar user request.',
          'Saving all API keys locally in an encrypted vault.',
          'Prefetching vector database entries before they are explicitly requested.'
        ],
        correctAnswerIndex: 1,
        explanation: 'Semantic caching evaluates the embedding vector of an incoming query and immediately serves a cached response if a high-similarity match is found, eliminating API costs and latency entirely.'
      ),
      ...domain5AdditionalQuestions,
      ...scrapedDomain5Questions,
    ],

  )
];

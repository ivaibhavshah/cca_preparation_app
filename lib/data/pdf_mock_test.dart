import '../models/exam.dart';

final List<Exam> pdfMockExams = [
  Exam(
    id: 'pdf_expanded_bank',
    title: 'CCA-F Expanded Question Bank (PDF)',
    description: '141 questions imported directly from the expanded PDF bank, covering all domains.',
    questions: [
      Question(
        id: 'pdf_q1',
        text: 'Which stop_reason value reliably indicates the agent loop should terminate?',
        options: [
          'tool_use',
          'end_turn',
          'max_tokens',
          'stop_sequence '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Only end_turn is the reliable completion signal. tool_use means continue; max_tokens means truncated; stop_sequence is application-specific.'
      ),
      Question(
        id: 'pdf_q2',
        text: 'What\'s the correct next step when the agent loop receives stop_reason == \'tool_use\'?',
        options: [
          'Stop and show assistant text to the user',
          'Execute the requested tool, append result to messages, re-send the request',
          'Ignore it and wait for end_turn',
          'Abort and log an error '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Run the requested tool, append the tool_result content block to conversation history, then re-send to Claude for the next iteration.'
      ),
      Question(
        id: 'pdf_q3',
        text: 'Which of these is an anti-pattern for detecting agent loop completion?',
        options: [
          'Checking stop_reason == \'end_turn\'',
          'Parsing assistant text for phrases like \'Task complete\' or \'Done\'',
          'Appending tool results to messages between iterations',
          'Letting Claude decide the next tool based on prior results '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Natural-language completion parsing is brittle and documented as an anti-pattern. Always rely on stop_reason.'
      ),
      Question(
        id: 'pdf_q4',
        text: 'A controller uses max_iterations=5 as the primary termination mechanism for all agents. What\'s wrong with this?',
        options: [
          'It\'s fine — just raise the limit',
          'It forces premature termination of valid multi-step work and ignores model-driven decisions',
          'It causes memory leaks',
          'It violates the MCP spec '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Iteration caps as the primary stop condition cut off legitimate work. They\'re a safety net, not the primary control signal.'
      ),
      Question(
        id: 'pdf_q5',
        text: 'Agents return tool_use but the controller never continues. Most likely cause?',
        options: [
          'The tool_result content block isn\'t being appended to messages before re-calling Claude',
          'max_tokens is too low',
          'tool_choice is set to \'any\'',
          'The model doesn\'t support tool use '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Every tool_use requires a matching tool_result appended to history in the next request. Without it, the conversation is malformed. Subdomain 1.2: Coordinator-Subagent Orchestration'
      ),
      Question(
        id: 'pdf_q6',
        text: 'A research system produces reports on \'AI impact on creative industries\' but only covers visual art. Coordinator logs show decomposition into \'AI in digital art\', \'AI in graphic design\', \'AI in photography\'. Subagents executed these perfectly. Root cause?',
        options: [
          'Synthesis agent lacks gap-detection',
          'Coordinator decomposed the topic too narrowly',
          'Search subagent queries insufficient',
          'Document analysis filtered non-visual sources '
        ],
        correctAnswerIndex: 1,
        explanation: '—  The coordinator owns decomposition. Narrow subtask definitions produce narrow coverage regardless of subagent quality.'
      ),
      Question(
        id: 'pdf_q7',
        text: 'Web-search and document-analysis agents both investigate overlapping subtopics, nearly doubling token usage without gaining breadth. Best fix?',
        options: [
          'Let both finish, then dedupe in coordinator',
          'Coordinator explicitly partitions research scope before delegating',
          'Shared-state mechanism so agents dynamically avoid each other',
          'Switch to sequential execution '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Upfront scope partitioning by the coordinator prevents duplication at the source. Post-hoc dedup wastes tokens; shared-state adds complexity; sequential kills parallelism.'
      ),
      Question(
        id: 'pdf_q8',
        text: 'A colleague proposes subagents communicate directly with one another, bypassing the coordinator, for latency savings. Primary argument against?',
        options: [
          'Direct comms require serialization only the coordinator can do',
          'Centralized coordinator enables observability, uniform error handling, and controlled information flow',
          'Coordinators batch calls to reduce API usage',
          'Direct calls bypass retry logic '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Hub-and-spoke centralizes observability and error handling. Direct communication fragments these, making debugging and evolution much harder.'
      ),
      Question(
        id: 'pdf_q9',
        text: 'A coordinator always runs web-search → doc-analysis → synthesis regardless of query. Simple queries waste time in unneeded stages. Best practice?',
        options: [
          'Keep the full pipeline — consistency matters',
          'Coordinator analyzes query requirements and dynamically selects subagents',
          'Let users specify stages',
          'Randomize stage order '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Dynamic subagent selection based on query requirements is a core coordinator responsibility — it adapts processing to complexity.'
      ),
      Question(
        id: 'pdf_q10',
        text: 'The coordinator evaluates synthesis output and finds coverage gaps. Correct pattern?',
        options: [
          'Accept the result and annotate gaps in the final report',
          'Re-delegate to search/analysis subagents with targeted queries, then re-invoke synthesis until coverage is sufficient',
          'Escalate to human reviewer',
          'Retry synthesis with identical inputs '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Iterative refinement: detect gaps, dispatch targeted subagent calls, re-synthesize. Retrying synthesis with same inputs yields same gaps. Subdomain 1.3: Subagent Invocation and Context Passing'
      ),
      Question(
        id: 'pdf_q11',
        text: 'For a coordinator to spawn subagents via the Task tool, what must be true?',
        options: [
          'Task in allowedTools',
          'A shared database',
          'PostToolUse hooks enabled',
          'fork_session enabled '
        ],
        correctAnswerIndex: 0,
        explanation: '—  allowedTools on the coordinator must contain \'Task\' — it\'s the spawning primitive.'
      ),
      Question(
        id: 'pdf_q12',
        text: 'Your Task call reads: `Task: \'Analyze the document\'`. The subagent repeatedly fails because it has no context. Fix?',
        options: [
          'Subagents auto-inherit history — the implementation is buggy',
          'Include full required context explicitly: document text, prior results, output format requirements',
          'Use shared memory',
          'Prefix with \'Inherit context: true\' '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Subagents do NOT inherit coordinator context. Every Task call must include all required context explicitly.'
      ),
      Question(
        id: 'pdf_q13',
        text: 'How do you spawn three subagents to run concurrently?',
        options: [
          'Emit multiple Task tool calls in a single coordinator response',
          'Issue Task calls across separate turns',
          'Use --parallel flag',
          'Spawn threads in controller code '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Multiple Task calls in one coordinator response run in parallel. Separate turns serialize them.'
      ),
      Question(
        id: 'pdf_q14',
        text: 'A coordinator prompt reads: \'Step 1: call web_search with query X. Step 2: call doc_analysis with the results.\' A reviewer says this is too procedural. What\'s better?',
        options: [
          'Keep the steps — determinism matters',
          'Specify research goals and quality criteria; let the coordinator adapt the procedure',
          'Move steps to few-shot examples',
          'Use fork_session per step '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Goal-oriented prompts enable adaptive decomposition. Procedural prompts constrain the coordinator to a fixed pipeline, losing adaptability.'
      ),
      Question(
        id: 'pdf_q15',
        text: 'When passing web_search results and document findings to the synthesis subagent, which practice preserves source attribution?',
        options: [
          'Concatenate everything as plain text',
          'Structured data formats separating content from metadata (URLs, document names, page numbers)',
          'Strip metadata for brevity',
          'Let synthesis re-fetch sources '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Structured formats preserve claim-source mappings through synthesis. Plain concatenation loses provenance. Subdomain 1.4: Multi-Step Workflows with Enforcement and Handoff'
      ),
      Question(
        id: 'pdf_q16',
        text: 'In 12% of cases, the support agent processes refunds without calling get_customer first, sometimes sending refunds to the wrong account. Best fix?',
        options: [
          'Programmatic precondition blocking lookup_order and process_refund until get_customer returns a verified ID',
          'Stronger prompt instructions',
          'Few-shot examples of correct ordering',
          'Routing classifier '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Deterministic guarantees require programmatic enforcement. Prompts are probabilistic — fine for preferences, unacceptable when money is at risk.'
      ),
      Question(
        id: 'pdf_q17',
        text: 'Refund policy: amounts over \$500 require human approval. Prompt instructions yield 98% compliance, not 100%. Correct design?',
        options: [
          'Re-train the model',
          'PreToolUse hook that blocks process_refund calls with amount > 500, redirects to escalate_to_human',
          'More few-shot examples',
          'Lower the threshold to \$100 '
        ],
        correctAnswerIndex: 1,
        explanation: '—  For compliance with financial/legal consequences, hooks give deterministic enforcement. 98% isn\'t acceptable for money.'
      ),
      Question(
        id: 'pdf_q18',
        text: 'A customer message contains three concerns (refund, address change, delivery date). How should the agent approach this?',
        options: [
          'Address only the first concern',
          'Decompose into distinct items, investigate each in parallel using shared context, synthesize a unified response',
          'Escalate immediately',
          'Ask customer to resend one at a time '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Decomposition + parallel investigation + unified synthesis respects the customer\'s time and coverage. Serial item-by-item processing misses interactions.'
      ),
      Question(
        id: 'pdf_q19',
        text: 'On escalating to a human, what must the handoff payload contain?',
        options: [
          'Raw conversation transcript',
          'Customer ID, root cause, actions taken, recommended action, refund/credit amount, escalation reason',
          'Only the customer ID — humans look up the rest',
          'The model\'s internal reasoning trace '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Human agents rarely see transcripts. The handoff must be self-contained and actionable. Subdomain 1.5: Agent SDK Hooks for Interception and Normalization'
      ),
      Question(
        id: 'pdf_q20',
        text: 'Different MCP tools return timestamps in different formats (Unix epoch, ISO 8601, \'Mar 5 2025\'). Cleanest normalization?',
        options: [
          'Ask the model to normalize in its response',
          'PostToolUse hook converts all timestamps to ISO 8601 before model sees them',
          'Normalize in the UI layer',
          'Use a PreToolUse hook '
        ],
        correctAnswerIndex: 1,
        explanation: '—  PostToolUse hooks intercept tool results before model processing — the right place for normalization.'
      ),
      Question(
        id: 'pdf_q21',
        text: 'Hooks provide ___ enforcement; prompt instructions provide ___ enforcement.',
        options: [
          'probabilistic / deterministic',
          'deterministic / probabilistic',
          'slow / fast',
          'legacy / modern '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Hooks execute in code — 100% deterministic. Prompts are interpreted by the model — probabilistic (>90% not 100%).'
      ),
      Question(
        id: 'pdf_q22',
        text: 'For which rule MUST you use a hook (not a prompt)?',
        options: [
          'Prefer concise answers',
          'Block refunds above \$500 automatically',
          'Use formal tone',
          'Prefer bulleted output '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Financial thresholds need deterministic enforcement via hooks. Tone and formatting are fine as prompts.'
      ),
      Question(
        id: 'pdf_q23',
        text: 'You want to block outgoing calls that violate compliance BEFORE they reach the tool. Which hook?',
        options: [
          'PostToolUse',
          'PreToolUse',
          'OnSessionStart',
          'OnMessage '
        ],
        correctAnswerIndex: 1,
        explanation: '—  PreToolUse intercepts a tool call before execution, allowing blocking or redirection. PostToolUse runs after.'
      ),
      Question(
        id: 'pdf_q24',
        text: 'When does a prompt-based rule outperform a hook-based rule?',
        options: [
          'Never — always use hooks',
          'For general preferences, tone, formatting, and soft guidance where 100% compliance isn\'t critical',
          'Only in CI/CD',
          'When hooks aren\'t supported '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Prompts are fine — even preferable for maintainability — for soft guidance. Hooks are for safety/compliance where failure has real consequences. Subdomain 1.6: Task Decomposition Strategies'
      ),
      Question(
        id: 'pdf_q25',
        text: 'A PR changes 14 files. A single-pass review yields inconsistent depth and contradictory findings (same pattern flagged in one file, approved in another). Best restructure?',
        options: [
          'Per-file local passes + a separate cross-file integration pass',
          'Require devs to split PRs',
          'Use a larger-context model',
          'Three independent full-PR passes with voting '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Attention dilutes across many files. Per-file passes ensure uniform depth; integration pass catches cross-file concerns.'
      ),
      Question(
        id: 'pdf_q26',
        text: 'Task: \'Add comprehensive tests to a legacy codebase.\' Scope unknown up-front. Decomposition strategy?',
        options: [
          'Fixed prompt chain: lint → test-gen → commit',
          'Adaptive: first map structure, identify high-impact areas, build a prioritized plan that evolves as dependencies surface',
          'Single mega-prompt',
          'Parallel subagents on each file '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Adaptive decomposition fits exploratory work where scope emerges. Fixed chains fit predictable repeatable workflows.'
      ),
      Question(
        id: 'pdf_q27',
        text: 'Your code review always runs: lint → security → style → performance, identical steps for every PR. Which decomposition pattern?',
        options: [
          'Prompt chaining (fixed sequential pipeline)',
          'Adaptive decomposition',
          'Fork-session',
          'Context windowing '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Prompt chaining is the right name for predictable fixed pipelines. Adaptive is for open-ended work.'
      ),
      Question(
        id: 'pdf_q28',
        text: 'Why split a 14-file review into per-file + integration passes instead of one big pass?',
        options: [
          'Rate limits',
          'Avoids attention dilution: deep analysis on each file + dedicated cross-file analysis',
          'Parallel execution',
          'Token cost savings '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Single-pass over many files causes attention dilution — uneven depth, inconsistent findings. Splitting guarantees each file gets focused analysis. Subdomain 1.7: Session State, Resumption, and Forking'
      ),
      Question(
        id: 'pdf_q29',
        text: 'You want to compare Redux vs Context API for refactoring, sharing the initial codebase analysis but diverging afterward. Best SDK feature?',
        options: [
          'Two fresh sessions, each re-doing discovery',
          'fork_session — inherit context to the branch point, diverge independently',
          '--resume from two terminals',
          'One session alternating questions '
        ],
        correctAnswerIndex: 1,
        explanation: '—  fork_session is designed for this: branches share pre-fork context and evolve independently. Fresh sessions waste discovery.'
      ),
      Question(
        id: 'pdf_q30',
        text: 'Files have changed significantly since your last session. Resume or restart?',
        options: [
          'Always --resume',
          'Fresh session with a structured summary of prior findings injected',
          '--resume, then ask the model to re-verify everything',
          'fork_session from the old one '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Stale tool results mislead. A fresh session with clean summary avoids stale data; --resume after major changes poisons context.'
      ),
      Question(
        id: 'pdf_q31',
        text: 'Which CLI flag resumes a named session?',
        options: [
          '--restore',
          '--resume',
          '--continue',
          '--session '
        ],
        correctAnswerIndex: 1,
        explanation: '—  --resume continues a specific named session.'
      ),
      Question(
        id: 'pdf_q32',
        text: 'You resumed a session, but it keeps producing wrong answers based on code that\'s been refactored since. Fix?',
        options: [
          'Abandon the session',
          'Inform the agent about specific file changes for targeted re-analysis, or restart fresh with a clean summary',
          'Increase max_tokens',
          'Switch models '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Two valid paths: explicit invalidation (tell the agent what changed) or fresh start with summary. Both beat silently continuing with stale data.  Domain 2: Tool Design & MCP Integration Exam weight: 18% Covers tool descriptions as primary selection mechanism, structured MCP error responses, tool allocation across agents, tool_choice modes, MCP server scoping (.mcp.json vs ~/.claude.json), and built-in tools (Read, Write, Edit, Bash, Grep, Glob). Subdomains covered in this section:   I 2.1   Tool Interface Design and Descriptions   I 2.2   Structured Error Responses   I 2.3   Tool Allocation and tool_choice   I 2.4   MCP Server Integration   I 2.5   Built-in Tools (Read, Write, Edit, Bash, Grep, Glob)  Subdomain 2.1: Tool Interface Design and Descriptions'
      ),
      Question(
        id: 'pdf_q33',
        text: 'What is the PRIMARY mechanism LLMs use to select which tool to call?',
        options: [
          'Tool name only',
          'Tool description (name + description in the tools array)',
          'Order in the tools array',
          'JSON schema complexity '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Descriptions (plus names) are the primary selection signal. Minimal or overlapping descriptions cause misrouting.'
      ),
      Question(
        id: 'pdf_q34',
        text: 'Your agent routes 45% of order queries to get_customer instead of lookup_order. Descriptions are \'Retrieves customer information\' / \'Retrieves order information\'. Lowest-effort fix?',
        options: [
          'Rewrite descriptions with input formats, example queries, edge cases, and when-to-use-vs-alternatives',
          'Add few-shot examples to the system prompt',
          'Build a routing classifier',
          'Merge the two tools '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Tool descriptions are the primary signal; rewriting them with specificity removes ambiguity at the source.'
      ),
      Question(
        id: 'pdf_q35',
        text: 'analyze_content (web-search) and analyze_document (document agent) have near-identical descriptions. Requests for uploaded reports misroute to web-search 45% of the time. Best fix?',
        options: [
          'Pre-routing classifier',
          'Rename analyze_content to extract_web_results and update description to explicitly cover web and URL sources',
          'Few-shot routing examples',
          'Expand only the document tool\'s description '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Renaming + precise description eliminates overlap at the root. Leaving the web-search tool unchanged leaves it attractive for misrouting.'
      ),
      Question(
        id: 'pdf_q36',
        text: 'Your system prompt says \'always verify customer details first\'. The agent overuses get_customer even when unnecessary. Why?',
        options: [
          'A bug',
          'Keyword-sensitive prompt instructions create unintended tool associations; \'verify\' attaches to get_customer',
          'Context window overflow',
          'Tool definition error '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Prompts with tool-adjacent keywords create unintended associations. Soften the instruction or make get_customer\'s description more precise about when to apply.'
      ),
      Question(
        id: 'pdf_q37',
        text: 'A general analyze_document tool handles metadata extraction, summarization, AND claim verification. Quality varies wildly. Best refactor?',
        options: [
          'Keep it general; use prompts to guide',
          'Split into extract_data_points, summarize_content, verify_claim_against_source — each with its own IO contract',
          'Add branching inside the tool',
          'Add more fields to the JSON schema '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Purpose-specific tools with defined IO contracts are more reliable. Generic tools force the model to guess which mode to operate in. Subdomain 2.2: Structured Error Responses'
      ),
      Question(
        id: 'pdf_q38',
        text: 'An MCP tool returns {"isError": true, "content": "Operation failed"}. What\'s wrong?',
        options: [
          'isError should be false',
          'It lacks structured metadata the agent needs to decide: retry, alternative, or escalate',
          'content must be numeric',
          'Errors can\'t be returned from MCP '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Structured errors need errorCategory, isRetryable, message, and context (attempted inputs, partial results). Generic errors strip the signal needed for recovery.'
      ),
      Question(
        id: 'pdf_q39',
        text: 'Classify: \'Orders API returned 503 Service Unavailable\'. Error category?',
        options: [
          'validation',
          'transient',
          'business',
          'permission '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Service outages are transient — retryable. Validation is input errors; business is policy violations; permission is access-denied.'
      ),
      Question(
        id: 'pdf_q40',
        text: 'A business-rule violation (e.g., refund exceeds allowed threshold) — what retryability flag?',
        options: [
          'isRetryable: true',
          'isRetryable: false with a customer-friendly explanation',
          'Omit the flag',
          'true, with exponential backoff '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Business-rule violations won\'t succeed on retry. Return false plus a human-readable message so the agent can explain and propose alternatives.'
      ),
      Question(
        id: 'pdf_q41',
        text: 'Subagent timeouts — where should retry happen?',
        options: [
          'Always at the coordinator',
          'Subagent does local recovery (1-2 retries) for transient failures, propagates only unresolvable errors with partial results',
          'Infinite retry inside subagent',
          'Abort whole workflow '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Local recovery reduces coordinator churn; unresolvable errors propagate with structured context.'
      ),
      Question(
        id: 'pdf_q42',
        text: 'A search returns zero results. Another returns timeout. Should the error responses look the same?',
        options: [
          'Yes, return \'no data\' in both cases',
          'No — \'zero results\' is a successful query; \'timeout\' is access failure needing retry decision. Different outcomes',
          'Yes, with different error codes',
          'Report both as errors '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Zero-results is valid signal; timeout is access failure. Conflating them leads to wrong recovery decisions. Subdomain 2.3: Tool Allocation and tool_choice'
      ),
      Question(
        id: 'pdf_q43',
        text: 'You gave an agent 18 tools \'for flexibility\'. Selection accuracy dropped. Why?',
        options: [
          'Rate limits',
          'Selection reliability degrades as decision complexity grows; 4-5 scoped tools outperform 18 broad ones',
          'Memory issues',
          'Token cost '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Each tool adds decision complexity. Scoped, role-specific toolsets improve reliability. Specialization beats generalization.'
      ),
      Question(
        id: 'pdf_q44',
        text: 'You must guarantee the next response is a structured tool call, not chat text. Which tool_choice?',
        options: [
          '\'auto\'',
          '\'any\'',
          '{type: \'tool\', name: \'...\'}',
          'null '
        ],
        correctAnswerIndex: 1,
        explanation: '—  \'any\' forces a tool call but lets the model choose which. \'auto\' allows chat text; specific-name picks one tool.'
      ),
      Question(
        id: 'pdf_q45',
        text: 'extract_metadata MUST run first before enrichment tools. Approach?',
        options: [
          'tool_choice: \'auto\'',
          'tool_choice: {type: \'tool\', name: \'extract_metadata\'} on first turn; process follow-ups in later turns',
          'Prompt instructions',
          'Sort tools array '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Forced specific-name selection on the first turn guarantees it runs. After metadata, enrichment proceeds normally.'
      ),
      Question(
        id: 'pdf_q46',
        text: 'Synthesis agent needs simple fact-checks mid-work, but shouldn\'t do arbitrary web searches. Design?',
        options: [
          'Give full web-search toolset',
          'Scoped verify_fact tool for simple checks; complex verification routed through coordinator',
          'No tools — route everything',
          'Let synthesis call any MCP tool '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Scoped cross-role tools fit high-frequency simple needs while preserving coordinator oversight for complex paths. Applies least-privilege. Subdomain 2.4: MCP Server Integration'
      ),
      Question(
        id: 'pdf_q47',
        text: 'Where do you define MCP servers shared across the team?',
        options: [
          '~/.claude.json',
          '.mcp.json at project root, committed to VCS, with env var placeholders for secrets',
          'CLAUDE.md',
          '.claude/commands/mcp.md '
        ],
        correctAnswerIndex: 1,
        explanation: '—  .mcp.json at project root + VCS = shared. User-level (~/.claude.json) is personal.'
      ),
      Question(
        id: 'pdf_q48',
        text: 'You need to commit MCP config, but the GitHub server requires a token. How?',
        options: [
          'Commit the token directly',
          'Use environment variable expansion: \${GITHUB_TOKEN}',
          'Use a placeholder and document substitution',
          'Store in CLAUDE.md '
        ],
        correctAnswerIndex: 1,
        explanation: '—  \${ENV_VAR} expansion is native and designed for this. Tokens live in environment; config lives in VCS.'
      ),
      Question(
        id: 'pdf_q49',
        text: 'For a standard Jira integration, custom MCP server or community one?',
        options: [
          'Always build custom',
          'Use community servers for standard integrations; reserve custom for team-specific workflows',
          'Always use community, no exceptions',
          'Never use MCP — direct API '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Community servers for standard integrations; custom for unique team workflows. Don\'t reinvent.'
      ),
      Question(
        id: 'pdf_q50',
        text: 'Your agent prefers built-in Grep over your team\'s MCP code-search tool that has richer metadata. Why, and fix?',
        options: [
          'Remove Grep from allowedTools',
          'Enhance the MCP tool\'s description to explain its specific advantages, unique data, and context built-ins can\'t provide',
          'Rename Grep',
          'Lower Grep\'s priority '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Stronger descriptions sell the MCP tool. Built-ins are familiar to the model; MCP tools need explicit value propositions.'
      ),
      Question(
        id: 'pdf_q51',
        text: 'What does an MCP resource provide that a tool doesn\'t?',
        options: [
          'Nothing — they\'re equivalent',
          'Read-only content catalogs (issue summaries, doc hierarchies, DB schemas) — an immediate \'map\' without exploratory tool calls',
          'Write access',
          'Authentication '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Resources expose browsable content catalogs so agents know what exists without exploratory probing. Tools are for actions. Subdomain 2.5: Built-in Tools (Read, Write, Edit, Bash, Grep, Glob)'
      ),
      Question(
        id: 'pdf_q52',
        text: 'Find all files matching **/*.test.tsx. Which tool?',
        options: [
          'Grep',
          'Glob',
          'Read',
          'Bash '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Glob = file path pattern matching. Grep = content search.'
      ),
      Question(
        id: 'pdf_q53',
        text: 'Find all callers of calculateRefund across a codebase. Which tool?',
        options: [
          'Grep',
          'Glob',
          'Write',
          'Bash '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Grep searches file contents. Use it to find all calls of calculateRefund.'
      ),
      Question(
        id: 'pdf_q54',
        text: 'Edit fails because the anchor text appears in multiple places in the file. Fallback?',
        options: [
          'Give up',
          'Read the full file, modify programmatically, Write the updated content',
          'Use Bash with sed',
          'Edit with a unique regex '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Read + Write is the documented fallback when Edit can\'t uniquely locate the anchor.'
      ),
      Question(
        id: 'pdf_q55',
        text: 'Best strategy for understanding a new codebase?',
        options: [
          'Read every file upfront',
          'Grep for entry points, Read the entries, Grep for usages of discovered names, Read followers — incrementally',
          'Ask the user to summarize',
          'Single Bash \'find .\' then read sequentially '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Incremental exploration (Grep → Read → Grep → Read) builds understanding without overwhelming context.  Domain 3: Claude Code Configuration & Workflows Exam weight: 20% Covers CLAUDE.md hierarchy (user/project/directory), @path imports, .claude/rules/ with YAML path-scoping, slash commands and skills with context:fork and allowed-tools, planning mode vs direct execution, iterative refinement, and CI/CD integration (-p, --output-format json, --json-schema). Subdomains covered in this section:   I 3.1   CLAUDE.md Hierarchy and Modular Organization   I 3.2   Custom Slash Commands and Skills   I 3.3   Path-Specific Rules for Conditional Loading   I 3.4   Planning Mode vs Direct Execution   I 3.5   Iterative Refinement   I 3.6   CI/CD Integration  Subdomain 3.1: CLAUDE.md Hierarchy and Modular Organization'
      ),
      Question(
        id: 'pdf_q56',
        text: 'A new teammate clones the repo and doesn\'t receive your coding standards. Your standards live at ~/.claude/CLAUDE.md. Fix?',
        options: [
          'Tell them to copy the file manually',
          'Move to .claude/CLAUDE.md (or root CLAUDE.md) and commit to VCS',
          'Upload to S3',
          'Paste into README '
        ],
        correctAnswerIndex: 1,
        explanation: '—  User-level (~/.claude/CLAUDE.md) is personal. Shared standards go project-level, in VCS.'
      ),
      Question(
        id: 'pdf_q57',
        text: 'CLAUDE.md has grown to 4000 lines covering React, Python, DB, and testing. Best refactor?',
        options: [
          'Keep it — Claude handles long context',
          'Split into .claude/rules/ topic files, or use @path imports from CLAUDE.md',
          'Delete what\'s rarely used',
          'One CLAUDE.md per directory '
        ],
        correctAnswerIndex: 1,
        explanation: '—  .claude/rules/ and @path imports are both documented modularization options. Directory-level CLAUDE.md fits dir-specific conventions, not topic splits.'
      ),
      Question(
        id: 'pdf_q58',
        text: 'How do you import an external standards file into CLAUDE.md?',
        options: [
          '{{ include \'./standards.md\' }}',
          '@./standards/coding-style.md (no space between @ and path)',
          'import \'./standards.md\'',
          ''
        ],
        correctAnswerIndex: 1,
        explanation: '—  @ immediately before the path. Both relative and absolute paths work; relative resolves against the importing file.'
      ),
      Question(
        id: 'pdf_q59',
        text: 'Claude isn\'t following certain rules intermittently across sessions. How do you diagnose which memory files are loaded?',
        options: [
          '/config',
          '/memory',
          '/debug',
          '/files '
        ],
        correctAnswerIndex: 1,
        explanation: '—  /memory shows and manages loaded memory/CLAUDE.md files.'
      ),
      Question(
        id: 'pdf_q60',
        text: 'Maximum nesting depth for @path imports in CLAUDE.md?',
        options: [
          '2',
          '5',
          '10',
          'Unlimited '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Maximum 5 levels of nested @path imports per documentation.'
      ),
      Question(
        id: 'pdf_q61',
        text: 'What\'s the correct precedence order for CLAUDE.md hierarchy levels?',
        options: [
          'User-level only',
          'All levels apply cumulatively: user + project + directory; more-specific layers complement, not replace',
          'Directory overrides project overrides user',
          'Project is the only one that matters '
        ],
        correctAnswerIndex: 1,
        explanation: '—  All three levels load and contribute. User adds personal preferences; project adds team standards; directory adds location-specific conventions. Subdomain 3.2: Custom Slash Commands and Skills'
      ),
      Question(
        id: 'pdf_q62',
        text: 'Store a /review command so all teammates get it on clone?',
        options: [
          '.claude/commands/ (committed to VCS)',
          '~/.claude/commands/',
          'CLAUDE.md',
          '.claude/config.json '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Project-scoped commands in .claude/commands/ (VCS). User-scoped is personal.'
      ),
      Question(
        id: 'pdf_q63',
        text: 'A skill produces very verbose codebase analysis that pollutes the main session context. Best config?',
        options: [
          'allowed-tools: []',
          'context: fork in SKILL.md frontmatter (runs in isolated subagent)',
          'verbose: false',
          'Move to ~/.claude/skills/ '
        ],
        correctAnswerIndex: 1,
        explanation: '—  context: fork runs the skill in an isolated subagent — verbose output stays there, only the summary returns.'
      ),
      Question(
        id: 'pdf_q64',
        text: 'Restrict a skill to read-only file operations. Which frontmatter?',
        options: [
          'context: readonly',
          'allowed-tools: [\'Read\', \'Grep\', \'Glob\']',
          'permissions: readonly',
          'deny: [\'Write\', \'Edit\'] '
        ],
        correctAnswerIndex: 1,
        explanation: '—  allowed-tools whitelist restricts what the skill can do — least-privilege security.'
      ),
      Question(
        id: 'pdf_q65',
        text: 'A skill is frequently invoked without a required path argument. Which frontmatter helps?',
        options: [
          'required-args',
          'argument-hint: \'Path to the directory to analyze\'',
          'prompt-on-empty',
          'default-arg '
        ],
        correctAnswerIndex: 1,
        explanation: '—  argument-hint surfaces a prompt when the skill is invoked without arguments.'
      ),
      Question(
        id: 'pdf_q66',
        text: 'You want a personalized variant of the team\'s /review without affecting teammates. Best approach?',
        options: [
          'Edit the project .claude/skills/review/SKILL.md',
          'Create ~/.claude/skills/my-review/SKILL.md — personal variant under a different name',
          'Rename the project skill',
          'Delete the project skill '
        ],
        correctAnswerIndex: 1,
        explanation: '—  User-level skills under a different name keep your variant personal without disrupting teammates.'
      ),
      Question(
        id: 'pdf_q67',
        text: 'Skill (.claude/skills/) vs CLAUDE.md — when to use which?',
        options: [
          'They\'re interchangeable',
          'Skills = on-demand task-specific workflows; CLAUDE.md = always-loaded universal standards',
          'Skills are deprecated',
          'CLAUDE.md is deprecated '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Skills run when you invoke them; CLAUDE.md is baseline context always in play. Subdomain 3.3: Path-Specific Rules for Conditional Loading'
      ),
      Question(
        id: 'pdf_q68',
        text: 'Your codebase has different conventions for React, API, and DB migrations. Tests are co-located across all three. You want the right conventions to apply automatically when Claude edits a file. Best approach?',
        options: [
          'Single root CLAUDE.md',
          'CLAUDE.md in every directory',
          '.claude/rules/ files with YAML frontmatter \'paths\' globs (e.g., paths: [\'**/*.test.tsx\'])',
          'Create a skill per convention '
        ],
        correctAnswerIndex: 2,
        explanation: '—  .claude/rules/ with path-scoped YAML frontmatter loads only when Claude edits matching files — ideal for conventions that apply by file type regardless of directory.'
      ),
      Question(
        id: 'pdf_q69',
        text: 'You want Terraform files (terraform/**/*) to load infra conventions only. Which technique?',
        options: [
          'A skill',
          '.claude/rules/infra.md with frontmatter paths: [\'terraform/**/*\']',
          'A separate repository',
          'A pre-commit hook '
        ],
        correctAnswerIndex: 1,
        explanation: '—  YAML paths frontmatter targets globs precisely. Rule loads only when editing matching files, saving context and tokens.'
      ),
      Question(
        id: 'pdf_q70',
        text: 'When should you choose a directory-level CLAUDE.md instead of a path-scoped .claude/rules/ file?',
        options: [
          'Always pick directory CLAUDE.md',
          'Directory CLAUDE.md when conventions are tied to one directory; path-scoped rules when conventions apply across files scattered through the codebase',
          'They\'re functionally equivalent',
          'Path-scoped rules are deprecated '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Directory CLAUDE.md for localized conventions; path globs for cross-directory file-type conventions (like tests everywhere).'
      ),
      Question(
        id: 'pdf_q71',
        text: 'Benefit of path-scoped loading vs putting everything in root CLAUDE.md?',
        options: [
          'No benefit',
          'Rules load only when relevant, saving context and reducing token cost; irrelevant rules don\'t compete for attention',
          'Faster Git operations',
          'Easier syntax '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Conditional loading keeps context focused on relevant guidance, improving quality and cost. Subdomain 3.4: Planning Mode vs Direct Execution'
      ),
      Question(
        id: 'pdf_q72',
        text: 'You must restructure a monolith into microservices — dozens of files, service-boundary decisions. Mode?',
        options: [
          'Planning mode — explore, understand dependencies, design, approve, then execute',
          'Direct execution with incremental commits',
          'Direct execution with a very detailed up-front prompt',
          'Direct execution, switch to planning if stuck '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Planning mode is designed for large-scope, multi-approach, architecturally consequential work. Direct execution is for single-file, well-scoped changes.'
      ),
      Question(
        id: 'pdf_q73',
        text: 'Adding a single date-validation conditional to one function based on a clear stack trace. Mode?',
        options: [
          'Planning mode',
          'Direct execution',
          'fork_session to test alternatives',
          '--resume a prior session '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Small, well-scoped changes don\'t need planning. Direct execution is faster and appropriate.'
      ),
      Question(
        id: 'pdf_q74',
        text: 'Library migration affects 45+ files. Best combined approach?',
        options: [
          'Skip planning',
          'Plan mode to investigate dependencies and design the migration, then direct execution to implement the approved plan',
          'Direct execution throughout',
          'Only planning, no execution '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Plan to design, execute to implement. Plan mode is safe exploration; execution implements the approved design.'
      ),
      Question(
        id: 'pdf_q75',
        text: 'During plan-mode investigation of a large codebase, verbose discovery output consumes the context window. How to mitigate?',
        options: [
          'Abort and use a larger-context model',
          'Use the Explore subagent to isolate verbose discovery and return only a summary',
          'Disable logging',
          'Use /compact aggressively '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Explore subagent isolates verbose output — the main session only receives a summary. Designed for exactly this. Subdomain 3.5: Iterative Refinement'
      ),
      Question(
        id: 'pdf_q76',
        text: 'Prose instructions keep producing inconsistent output transformations. Most effective fix?',
        options: [
          'Longer prose',
          '2-3 concrete input/output examples',
          'Switch to a different model',
          'Split into more steps '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Concrete input/output examples are the most effective way to communicate expected transformations when prose is interpreted inconsistently.'
      ),
      Question(
        id: 'pdf_q77',
        text: 'You\'re implementing a complex transformation. What workflow gives the most reliable result?',
        options: [
          'Implement, then write tests',
          'Write tests first (covering expected behavior, edge cases, performance), then iterate by sharing test failures to guide improvement',
          'Skip tests',
          'Let Claude pick test cases '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Test-driven iteration: tests first, then failures become concrete feedback for the model to converge on correct behavior.'
      ),
      Question(
        id: 'pdf_q78',
        text: 'You need Claude to build a caching layer in an unfamiliar domain. Which pattern surfaces non-obvious design considerations?',
        options: [
          'Provide all details up-front',
          'Interview pattern: have Claude ask clarifying questions about invalidation, stale reads, per-user vs global, expected data volume BEFORE implementing',
          'Implement, iterate',
          'Copy similar code from another project '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Interview pattern surfaces design considerations the developer may not have anticipated before implementation starts.'
      ),
      Question(
        id: 'pdf_q79',
        text: 'Three issues in a single change. Two are independent; one interacts with a third. How do you present fixes?',
        options: [
          'Always sequential',
          'Interacting issues in one message (so Claude sees the interdependencies); independent issues can be fixed sequentially',
          'Always batched',
          'Let Claude decide '
        ],
        correctAnswerIndex: 1,
        explanation: '—  When fixes interact, give them together so the model can resolve them coherently. Independent issues are fine serially. Subdomain 3.6: CI/CD Integration'
      ),
      Question(
        id: 'pdf_q80',
        text: 'CI pipeline runs `claude "Analyze this PR for security issues"` but hangs waiting for interactive input. Fix?',
        options: [
          'Set CLAUDE_HEADLESS=true',
          'Use the -p (or --print) flag',
          'Redirect stdin from /dev/null',
          'Use --batch '
        ],
        correctAnswerIndex: 1,
        explanation: '—  -p / --print is the documented non-interactive mode: processes the prompt, prints to stdout, exits.'
      ),
      Question(
        id: 'pdf_q81',
        text: 'Your CI review emits prose. You want each finding as an inline PR comment with file, line, severity, suggested fix. Best approach?',
        options: [
          'Add output-format section to CLAUDE.md',
          'Include explicit formatting instructions in the prompt',
          'Use --output-format json with --json-schema, then parse and post via GitHub API',
          'Use a second Claude call to summarize into JSON '
        ],
        correctAnswerIndex: 2,
        explanation: '—  --output-format json + --json-schema enforces structure at the CLI level — guaranteed well-formed parseable findings.'
      ),
      Question(
        id: 'pdf_q82',
        text: 'Subtle issues keep getting through to reviewers even though the generation log shows the model considered them. Root-cause fix?',
        options: [
          'Run a second independent Claude instance (without generation reasoning in context) to review',
          'Enable extended thinking during generation',
          'Add self-review instructions to the generation prompt',
          'Include all test files in generation context '
        ],
        correctAnswerIndex: 0,
        explanation: '—  A session that generated code retains its reasoning and resists challenging its own decisions. An independent instance finds subtle issues via \'fresh eyes\'.'
      ),
      Question(
        id: 'pdf_q83',
        text: 'Re-running review after new commits produces duplicate comments. Fix?',
        options: [
          'Re-run with higher temperature',
          'Include prior review findings in context, instruct Claude to report only new or still-unaddressed issues',
          'Skip review on follow-up commits',
          'Always delete prior comments '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Passing prior findings lets Claude deduplicate against them and surface only new/still-open issues.'
      ),
      Question(
        id: 'pdf_q84',
        text: 'CI-generated tests often duplicate scenarios already covered. Fix?',
        options: [
          'Post-process and dedupe',
          'Provide existing test files in context so test-gen avoids suggesting already-covered scenarios',
          'Cap max test count',
          'Generate only one test '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Existing tests + CLAUDE.md standards produce focused, non-redundant new tests.  Domain 4: Prompt Engineering & Structured Output Exam weight: 20% Covers explicit criteria vs vague instructions, few-shot prompting as the primary technique for output consistency, JSON schema design (required vs nullable, enums with \'other\'/\'unclear\'), validation+retry loops, Message Batches API tradeoffs (50% savings, 24h window, no tool-use mid-request), and multi-instance/multi-pass review architectures. Subdomains covered in this section:   I 4.1   Explicit Criteria and Precision   I 4.2   Few-Shot Prompting for Consistency   I 4.3   Structured Output with tool_use and JSON Schemas   I 4.4   Validation, Retries, and Feedback Loops   I 4.5   Batch Processing Strategies   I 4.6   Multi-Instance and Multi-Pass Review  Subdomain 4.1: Explicit Criteria and Precision'
      ),
      Question(
        id: 'pdf_q85',
        text: 'Automated review produces findings like \'complex logic\' and \'potential null pointer\' without specific fixes. Most reliable remediation?',
        options: [
          'Refine prose instructions further',
          'Add 3-4 few-shot examples showing the exact format: location, issue, severity, concrete fix',
          'Split into two passes',
          'Expand context with more surrounding code '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Few-shot examples are the most reliable technique for format consistency. Prose is probabilistic; concrete examples unambiguously demonstrate the expected structure.'
      ),
      Question(
        id: 'pdf_q86',
        text: 'Vague instruction: \'Check comment accuracy\'. What\'s a better explicit-criteria version?',
        options: [
          '\'Be more conservative\'',
          '\'Flag a comment ONLY IF: (1) it contradicts actual code behavior, (2) references a non-existent function/variable, or (3) is a TODO for a bug already fixed\'',
          '\'Only high-confidence findings\'',
          '\'Ignore comments\' '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Enumerated concrete criteria massively outperform vague guidance like \'be conservative\' or \'high confidence\'.'
      ),
      Question(
        id: 'pdf_q87',
        text: 'One finding category has a 40% false-positive rate, eroding developer trust in all categories. Best interim action?',
        options: [
          'Ignore the problem',
          'Temporarily disable the high-FP category while improving its prompt/criteria; keep reliable categories active',
          'Disable all categories',
          'Push through '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Trust is cross-category. Silence a noisy category and rebuild trust in the others while you improve the problem prompt.'
      ),
      Question(
        id: 'pdf_q88',
        text: 'How do you define severity levels consistently?',
        options: [
          'Just enum values',
          'Explicit criteria for each severity level with concrete code examples (CRITICAL: NullPointerException during payment; HIGH: SQL injection; etc.)',
          'Let the model infer',
          'Randomize '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Severity classification is unreliable without concrete examples. Show the model what \'critical\' vs \'high\' vs \'medium\' looks like in real code. Subdomain 4.2: Few-Shot Prompting for Consistency'
      ),
      Question(
        id: 'pdf_q89',
        text: 'Extracting informal measurements like \'two handfuls of rice\' or \'a pinch of salt\'. Rule-based prompts keep missing cases. Best technique?',
        options: [
          'Few-shot input/output examples: \'two handfuls\' → {\'amount\': \'~100g\', \'precision\': \'approximate\'}',
          'Larger regex library in the prompt',
          'Rules engine only',
          'Reject non-standard inputs '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Few-shot is ideal for fuzzy normalization the model can generalize. Rules-only can\'t cover the diversity of informal measurements.'
      ),
      Question(
        id: 'pdf_q90',
        text: 'How many few-shot examples are typically sufficient for ambiguous scenarios?',
        options: [
          '10+',
          '2-4 targeted examples with reasoning for the chosen action',
          'Exactly 1',
          '0 — rely on instructions '
        ],
        correctAnswerIndex: 1,
        explanation: '—  2-4 targeted examples are the documented sweet spot. More adds tokens without proportional benefit; one is rarely enough for generalization.'
      ),
      Question(
        id: 'pdf_q91',
        text: 'You want few-shot examples to reduce false positives (e.g., distinguishing acceptable from genuine issues in code review). Best pattern?',
        options: [
          'Only show examples of issues',
          'Show BOTH acceptable patterns (do not flag) AND genuine issues (flag) — contrastive pairs enable generalization',
          'Only show acceptable patterns',
          'Random examples '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Contrastive few-shot (accept/reject pairs) enables the model to learn the boundary. One-sided examples create biased behavior.'
      ),
      Question(
        id: 'pdf_q92',
        text: 'Different documents have different structures (inline citations vs bibliography refs). Extraction quality varies. Few-shot approach?',
        options: [
          'One example',
          'One example per structural variant (inline citations, bibliography, methodology-section) so the model recognizes each pattern',
          'Generic examples',
          'No examples, rely on schema '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Cover each structural variant with an example. The model generalizes the pattern per-variant.'
      ),
      Question(
        id: 'pdf_q93',
        text: 'Required fields in the schema are often extracted as empty strings when the info isn\'t really there. Few-shot fix?',
        options: [
          'Make all fields required',
          'Show few-shot examples where missing info yields null (with the schema making those fields nullable)',
          'Increase temperature',
          'Remove optional fields '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Demonstrating null-on-missing + nullable schema stops the model from filling required fields with empties or fabrications. Subdomain 4.3: Structured Output with tool_use and JSON Schemas'
      ),
      Question(
        id: 'pdf_q94',
        text: 'Most reliable way to guarantee schema-compliant JSON output?',
        options: [
          'Ask for JSON in the prompt',
          'tool_use with a JSON schema as input parameters',
          'Regex post-processing',
          'JSON.parse with try/catch '
        ],
        correctAnswerIndex: 1,
        explanation: '—  tool_use with JSON schemas eliminates syntax errors entirely. It\'s the documented most-reliable mechanism.'
      ),
      Question(
        id: 'pdf_q95',
        text: 'Some extracted fields may legitimately be absent from the source. Schema design?',
        options: [
          'Mark every field required',
          'type: [\'string\', \'null\'] for potentially-absent fields; only truly-always-present fields are required',
          'Use \'\' as sentinel',
          'Custom \'missing\' enum '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Required fields push the model to fabricate. Nullable types let the model honestly return null. Reserve \'required\' for info always present.'
      ),
      Question(
        id: 'pdf_q96',
        text: 'You want an enum that also accepts extensible categorization (new categories not originally anticipated). Pattern?',
        options: [
          'Remove the enum',
          'enum: [...standard values, \'other\'] + a nullable detail_string field for \'other\' cases',
          'Make it a free-form string',
          'Reject non-enum values '
        ],
        correctAnswerIndex: 1,
        explanation: '—  \'other\' + detail string preserves info outside the original enum without losing structure.'
      ),
      Question(
        id: 'pdf_q97',
        text: 'When to add an \'unclear\' enum value?',
        options: [
          'Never',
          'When the model can\'t confidently pick a category — honest \'unclear\' beats a wrong category',
          'Always',
          'Only for strings '
        ],
        correctAnswerIndex: 1,
        explanation: '—  \'Unclear\' signals genuine ambiguity. Without it, the model is forced to pick a wrong category, degrading downstream processing.'
      ),
      Question(
        id: 'pdf_q98',
        text: 'tool_choice: \'any\' vs forced specific tool vs \'auto\' — which for \'guarantee the model picks the best matching extraction schema from several\'?',
        options: [
          '\'auto\'',
          '\'any\' — forces a tool call but lets the model choose',
          '{type: \'tool\', name: \'...\'}',
          'null '
        ],
        correctAnswerIndex: 1,
        explanation: '—  \'any\' guarantees structured output while letting the model match the best schema to the input.'
      ),
      Question(
        id: 'pdf_q99',
        text: 'Schemas guarantee syntactic validity. What doesn\'t it guarantee?',
        options: [
          'Nothing — schemas guarantee everything',
          'Semantic correctness: schemas can\'t catch \'line_items sum to 145 but stated total is 150\' or values in wrong fields',
          'Only field names',
          'Token limits '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Semantic errors (bad values, arithmetic inconsistencies) need validation checks and retry with feedback — schemas alone aren\'t enough. Subdomain 4.4: Validation, Retries, and Feedback Loops'
      ),
      Question(
        id: 'pdf_q100',
        text: 'Extraction returns \'total=150\' but line_items sum to 145. Best remediation?',
        options: [
          'Retry with validation feedback including the original document, the wrong extraction, and the specific error',
          'Switch to a larger model',
          'More schema fields',
          'Lower max_tokens '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Semantic errors need validation + retry with concrete error feedback. Retries with the original doc + error work when info is present.'
      ),
      Question(
        id: 'pdf_q101',
        text: 'When will retry-with-feedback NOT help?',
        options: [
          'Never — retries always help',
          'When the required information is not in the source (e.g., it\'s in a different doc not provided) or when retries hit the same model bias',
          'Only for syntax errors',
          'Only for numeric errors '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Retries fix correctable errors the model can self-correct with feedback. They can\'t conjure info that isn\'t in the source.'
      ),
      Question(
        id: 'pdf_q102',
        text: 'You want to track which code constructs trigger false-positive findings so you can improve prompts. Design?',
        options: [
          'Free-text notes',
          'Add a detected_pattern field capturing the pattern that triggered the finding — enables systematic FP analysis',
          'Log at the model level',
          'Screenshot findings '
        ],
        correctAnswerIndex: 1,
        explanation: '—  detected_pattern enables dashboards/analysis across dismissed findings, exposing FP-prone patterns to fix in prompts.'
      ),
      Question(
        id: 'pdf_q103',
        text: 'Self-correction for arithmetic inconsistencies — extraction pattern?',
        options: [
          'Trust the extraction',
          'Extract both calculated_total (from items) and stated_total (from the document); add conflict_detected boolean',
          'Post-process',
          'Human review only '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Dual extraction + conflict flag enables the pipeline to route inconsistencies to review without relying on a separate validation pass. Subdomain 4.5: Batch Processing Strategies'
      ),
      Question(
        id: 'pdf_q104',
        text: 'Message Batches API provides ___% savings and up to ___ hour processing window.',
        options: [
          '25% / 12h',
          '50% / 24h',
          '75% / 48h',
          '10% / 1h '
        ],
        correctAnswerIndex: 1,
        explanation: '—  50% savings, up to 24-hour processing window, no latency SLA guarantee.'
      ),
      Question(
        id: 'pdf_q105',
        text: 'Two workloads: (1) blocking pre-merge check developers wait on, (2) overnight tech-debt report. Manager wants both on Batches API. Your response?',
        options: [
          'Move both to batch',
          'Keep both synchronous',
          'Batch for overnight only; pre-merge stays synchronous',
          'Batch with synchronous fallback '
        ],
        correctAnswerIndex: 2,
        explanation: '—  Batches save 50% but can take 24h. Developers can\'t wait; overnight reports can. Only tech-debt fits Batches.'
      ),
      Question(
        id: 'pdf_q106',
        text: 'Iterative CI review where Claude requests imports/tests mid-analysis. Can it use Batches API?',
        options: [
          'Yes, with a wrapper',
          'No — Batches is fire-and-forget; can\'t execute tools mid-request and feed results back',
          'Yes with --tools=async',
          'Only for read-only tools '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Batches is single-request → single-response. Multi-turn tool-calling requires mid-request tool execution, which Batches can\'t do.'
      ),
      Question(
        id: 'pdf_q107',
        text: 'Batch of 100 documents submitted. 5 fail due to context-limit overflow. How do you recover?',
        options: [
          'Resubmit the full batch',
          'Identify failures by custom_id; resubmit only the 5 with modifications (chunking for context-overflow)',
          'Give up',
          'Run synchronously instead '
        ],
        correctAnswerIndex: 1,
        explanation: '—  custom_id correlates requests and responses; resubmit only failed items with targeted modifications.'
      ),
      Question(
        id: 'pdf_q108',
        text: 'SLA requires results in 30 hours. Batch window is up to 24 hours. Submission cadence?',
        options: [
          'Any time',
          'Submission window = 30 − 24 = 6 hours before the deadline; typically smaller windows (e.g., 4h) for safety',
          '24 hours before',
          'Continuously '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Leave the batch window (24h) as headroom against the SLA. 4h operational submission windows give safety margin. Subdomain 4.6: Multi-Instance and Multi-Pass Review'
      ),
      Question(
        id: 'pdf_q109',
        text: 'Same Claude session generated code AND now reviews it — issues are being missed that a peer would catch. Mechanism?',
        options: [
          'Token budget',
          'The session retains reasoning context from generation, making it less likely to challenge its own decisions',
          'Rate limits',
          'Model size '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Reasoning context biases the model toward its prior conclusions. An independent instance without that context challenges decisions effectively.'
      ),
      Question(
        id: 'pdf_q110',
        text: 'PR spans 14 files. How do you structure review?',
        options: [
          'Single full-PR pass',
          'Per-file local passes + separate cross-file integration pass',
          'Random file at a time',
          'Only review the biggest file '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Per-file depth + integration pass for cross-file concerns. Prevents attention dilution and inconsistent findings.'
      ),
      Question(
        id: 'pdf_q111',
        text: 'You want calibrated review routing — some findings go to human review, others auto-accept. Mechanism?',
        options: [
          'Random sampling only',
          'Have the model self-report confidence alongside each finding; calibrate thresholds with labeled validation data',
          'Accept everything',
          'Reject everything below 50% token probability '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Self-reported confidence + calibration routes limited human review capacity where it matters most.  Domain 5: Context Management & Reliability Exam weight: 15% Covers progressive summarization risks, lost-in-the-middle effect, tool-result trimming, escalation patterns and ambiguity resolution, multi-agent error propagation, scratchpad files for long codebase investigations, confidence calibration with stratified sampling, and provenance preservation for multi-source synthesis. Subdomains covered in this section:   I 5.1   Conversation Context Preservation   I 5.2   Escalation Patterns and Ambiguity Resolution   I 5.3   Multi-Agent Error Propagation   I 5.4   Context Management in Large Codebases   I 5.5   Human Review and Confidence Calibration   I 5.6   Provenance and Multi-Source Synthesis  Subdomain 5.1: Conversation Context Preservation'
      ),
      Question(
        id: 'pdf_q112',
        text: 'Aggregated subagent outputs total ~75K tokens. Synthesis reliably cites first 15K and last 10K tokens but misses critical findings in middle 50K — even when they directly answer the question. Best restructure?',
        options: [
          'Key-findings summary at top + explicit section headers throughout',
          'Summarize everything to <20K tokens',
          'Stream incrementally',
          'Rotate which subagent\'s output goes first '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Primacy puts critical findings in the most reliably processed position. Section headers help navigate mid-input content. Summarization loses fidelity.'
      ),
      Question(
        id: 'pdf_q113',
        text: 'Progressive summarization risk during long conversations?',
        options: [
          'Nothing',
          'Numeric values, percentages, dates, and customer-stated expectations get condensed into vague phrases (\'about\', \'roughly\')',
          'Only proper nouns',
          'Only timestamps '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Summarization tends to blur specifics. Extract transactional facts into a persistent block outside summarization.'
      ),
      Question(
        id: 'pdf_q114',
        text: 'lookup_order returns 40+ fields but only 5 are relevant for the current task. Best handling?',
        options: [
          'Accept and move on',
          'PostToolUse hook trims tool output to the relevant fields before the model sees it',
          'Tell the model to ignore the extras',
          'Raise max_tokens '
        ],
        correctAnswerIndex: 1,
        explanation: '—  PostToolUse trimming keeps context lean and focused. Relevant-only fields reduce noise and cost.'
      ),
      Question(
        id: 'pdf_q115',
        text: 'In a long customer-support session, you need amounts, dates, and statuses to persist reliably across summarizations. Design?',
        options: [
          'Trust history',
          'Extract transactional facts into a persistent \'case facts\' block included in every prompt, outside summarized history',
          'Re-extract each turn',
          'Ask the customer to repeat '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Persistent case facts block insulates key data from summarization. It\'s sent fresh each turn, independent of history compression.'
      ),
      Question(
        id: 'pdf_q116',
        text: 'Do you always need to send full conversation history in API requests?',
        options: [
          'No — state persists server-side',
          'Yes — each API call is independent; you send the full history every time',
          'Only the last message',
          'Only if you enable history '
        ],
        correctAnswerIndex: 1,
        explanation: '—  The API is stateless. You must send the full (possibly compressed) conversation history with every request to maintain coherence. Subdomain 5.2: Escalation Patterns and Ambiguity Resolution'
      ),
      Question(
        id: 'pdf_q117',
        text: 'Agent resolves only 55% of issues; target is 80%. It escalates simple cases and tries to handle complex policy exceptions autonomously. Fix?',
        options: [
          'Explicit escalation criteria + few-shot examples showing when to escalate vs resolve',
          'Self-rated confidence score with auto-escalate',
          'Separate classifier trained on history',
          'Sentiment analysis '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Explicit criteria with few-shot demonstrate decision boundaries. Confidence self-rating is unreliable; sentiment != complexity.'
      ),
      Question(
        id: 'pdf_q118',
        text: 'Customer explicitly says \'I want to speak to a manager\'. Correct action?',
        options: [
          'Acknowledge, offer to solve first',
          'Escalate immediately without attempting autonomous resolution',
          'Ask clarifying questions',
          'Analyze sentiment '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Explicit human requests are immediate-escalation triggers. Don\'t try to talk them out of it.'
      ),
      Question(
        id: 'pdf_q119',
        text: 'Customer says \'this is outrageous, I\'m unhappy with quality\'. Correct response pattern?',
        options: [
          'Escalate immediately',
          'Acknowledge frustration, offer concrete resolution (replacement/refund), escalate only if customer reiterates the preference for a human',
          'Ignore and proceed',
          'Apologize profusely '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Acknowledge → resolve → escalate on reiteration. Frustration alone isn\'t an escalation trigger.'
      ),
      Question(
        id: 'pdf_q120',
        text: 'get_customer returns multiple matches for the customer\'s name. Best action?',
        options: [
          'Pick the most recent account',
          'Ask the customer for an additional identifier (email, order ID) rather than guessing',
          'Escalate immediately',
          'rather than guessing C) Escalate immediately D) Process all of them '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Ambiguity → ask for disambiguating info. Heuristic selection can route refunds/info to the wrong person.'
      ),
      Question(
        id: 'pdf_q121',
        text: 'Policy silent on competitor price matching; customer requests it. Escalate or decline?',
        options: [
          'Decline autonomously',
          'Escalate to a human — policy gaps are outside the agent\'s authority',
          'Make up a policy',
          'Apply the standard refund flow '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Policy gaps are escalation triggers. The agent shouldn\'t invent policy; humans decide edge cases.'
      ),
      Question(
        id: 'pdf_q122',
        text: 'Why is sentiment analysis NOT a reliable escalation trigger?',
        options: [
          'Too slow',
          'Customer mood doesn\'t correlate with case complexity; frustrated customers can have simple issues, and calm ones can have complex ones',
          'Privacy issues',
          'Model can\'t do sentiment '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Escalation should track case complexity, not emotion. Sentiment is orthogonal. Subdomain 5.3: Multi-Agent Error Propagation'
      ),
      Question(
        id: 'pdf_q123',
        text: 'Web-search subagent times out. Best error payload to the coordinator?',
        options: [
          'Structured: failure_type, attempted_query, partial_results, alternative_approaches',
          'Generic \'search unavailable\'',
          'Empty result marked success',
          'Propagate exception top-level '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Structured context lets the coordinator choose: retry, alternative path, or partial synthesis. Generic and silent-success are anti-patterns.'
      ),
      Question(
        id: 'pdf_q124',
        text: 'Subagent silently returns empty results when a search fails. Problem?',
        options: [
          'Token cost',
          'Coordinator can\'t distinguish \'no matches\' from \'search broke\' — leads to false conclusions about coverage',
          'Rate limits',
          'Latency '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Silent suppression destroys signal. Coordinator needs to know whether a search succeeded-with-no-results or failed.'
      ),
      Question(
        id: 'pdf_q125',
        text: '5 of 5 source categories needed; 3 succeed, 2 time out. Synthesis must proceed. How do you structure the final report?',
        options: [
          'Pretend everything worked',
          'Synthesize with coverage annotations: which findings are well-supported vs which have gaps due to unavailable sources',
          'Fail the whole task',
          'Retry until all succeed '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Coverage annotations preserve value from successful work while honestly propagating uncertainty for informed decisions.'
      ),
      Question(
        id: 'pdf_q126',
        text: 'A single subagent failure aborts the whole workflow. Is this a good pattern?',
        options: [
          'Good — fail fast',
          'Anti-pattern — partial results are often usable and aborting wastes all completed work',
          'Good if time-critical',
          'Only if the failure is catastrophic '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Resilient multi-agent systems preserve partial results and annotate gaps. Fail-fast discards value.'
      ),
      Question(
        id: 'pdf_q127',
        text: 'Timeout (access failure) vs zero results (valid empty) — same error handling?',
        options: [
          'Same',
          'Different: timeout is access failure needing retry decision; zero-results is a valid successful query that informs the coordinator',
          'Zero-results is always an error',
          'Depends on the tool '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Conflating these leads to wrong recovery. Zero-results is signal; timeout is failure. Subdomain 5.4: Context Management in Large Codebases'
      ),
      Question(
        id: 'pdf_q128',
        text: 'Long investigation — the model starts giving inconsistent answers referencing \'typical patterns\' rather than the specific classes it earlier discovered. What\'s happening?',
        options: [
          'Model bug',
          'Context degradation — specific earlier findings are lost or muddled as context fills with new info',
          'Network issues',
          'Rate limiting '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Long sessions lose specificity. The model falls back to generic patterns instead of concrete findings.'
      ),
      Question(
        id: 'pdf_q129',
        text: 'Remedy for context degradation in long investigations?',
        options: [
          'Increase max_tokens',
          'Scratchpad file — write key findings to disk; reference or re-read when needed',
          'Restart frequently',
          'Lower temperature '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Scratchpad files persist specifics beyond a session\'s context. Agent can consult them instead of re-discovering.'
      ),
      Question(
        id: 'pdf_q130',
        text: 'You\'re about to dig deep into a subsystem. How do you prevent that exploration from polluting main context?',
        options: [
          'Keep it all in main',
          'Spawn a subagent (or Explore) for the investigation; only a summary returns to main',
          'Quiet mode',
          'Disable logging '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Subagent delegation isolates verbose output — main agent gets only a summary, preserving its context budget.'
      ),
      Question(
        id: 'pdf_q131',
        text: 'Context is filling with verbose tool output during an extended exploration. Immediate-term tactic?',
        options: [
          '/compact — summarize prior history to free context',
          '/restart',
          '/memory',
          '/debug '
        ],
        correctAnswerIndex: 0,
        explanation: '—  /compact summarizes history to free context. Know its tradeoff: specifics like numbers/dates may be blurred in summarization.'
      ),
      Question(
        id: 'pdf_q132',
        text: 'You need multi-agent workflows to survive crashes. Design?',
        options: [
          'Hope for the best',
          'Each agent exports state to a known location; coordinator loads a manifest on resume and re-injects state',
          'Use SQLite',
          'Only run short tasks '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Structured state exports + a coordinator manifest enable resume with full context reconstruction. Subdomain 5.5: Human Review and Confidence Calibration'
      ),
      Question(
        id: 'pdf_q133',
        text: 'Extraction pipeline reports 97% aggregate accuracy, yet some customers complain about systematic errors on specific document types. How do you validate readiness for full automation?',
        options: [
          'Trust the 97%',
          'Stratified random sampling — measure accuracy by document type AND field, not only overall',
          'Increase aggregate sample size',
          'More schema fields '
        ],
        correctAnswerIndex: 1,
        explanation: '—  97% aggregate can mask 40% errors on a specific type. Stratified sampling exposes hidden failure modes.'
      ),
      Question(
        id: 'pdf_q134',
        text: 'How do you calibrate which extractions route to human review?',
        options: [
          'Random',
          'Field-level confidence scores calibrated using labeled validation data; low-confidence + ambiguous-source extractions route to human',
          'Review everything',
          'Review nothing above 50% '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Calibrated field-level confidence + targeted routing uses limited human review capacity efficiently.'
      ),
      Question(
        id: 'pdf_q135',
        text: 'Why do you need ongoing stratified sampling even when automation is mature?',
        options: [
          'You don\'t',
          'To detect novel error patterns from new document types or content drift that aggregate monitoring misses',
          'Regulatory only',
          'For training data '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Drift detection: new document types or gradual content changes create new error modes sampling catches early.'
      ),
      Question(
        id: 'pdf_q136',
        text: 'You got a labeled validation set. What\'s the right use for confidence calibration?',
        options: [
          'Use it as training data',
          'Map model-reported confidences to actual accuracy on the validation set; set thresholds where accuracy meets your required bar',
          'Ignore',
          'Random thresholds '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Calibration maps self-reported confidence to true accuracy using the validation set, turning arbitrary scores into actionable thresholds. Subdomain 5.6: Provenance and Multi-Source Synthesis'
      ),
      Question(
        id: 'pdf_q137',
        text: 'Two credible sources give conflicting statistics (government: 40%; industry: 12%). How should the document-analysis subagent handle?',
        options: [
          'Credibility heuristic pick',
          'Both included without conflict marker',
          'Escalate immediately',
          'Complete analysis, explicitly annotate conflict with attribution, pass to coordinator for reconciliation '
        ],
        correctAnswerIndex: 3,
        explanation: '—  Preserve both with attribution, flag conflict, let coordinator reconcile. Arbitrary picks destroy info.'
      ),
      Question(
        id: 'pdf_q138',
        text: 'Source A says 10%, Source B says 15%. You call it contradiction. What\'s missing?',
        options: [
          'Publication/collection dates — temporal difference may not be contradiction',
          'Original language',
          'Author credentials',
          'URL '
        ],
        correctAnswerIndex: 0,
        explanation: '—  Without dates, change-over-time looks like contradiction. Always include temporal metadata.'
      ),
      Question(
        id: 'pdf_q139',
        text: 'What must subagents output to preserve provenance through synthesis?',
        options: [
          'Just the claims',
          'Structured claim-source mappings: URL, document name, relevant excerpts, publication date, methodology',
          'Free-form prose',
          'Confidence only '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Claim-source mappings are the primitive the synthesis agent must preserve and merge — without them, attribution is lost.'
      ),
      Question(
        id: 'pdf_q140',
        text: 'Best rendering style for different content types in a synthesized report?',
        options: [
          'Uniform prose everywhere',
          'Financial data → tables; news/analysis → prose; technical findings → structured lists; time series → chronological — pick rendering by content type',
          'Uniform bullet points',
          'Whatever the model picks '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Different data types communicate best in different formats. Forcing uniform rendering degrades comprehension.'
      ),
      Question(
        id: 'pdf_q141',
        text: 'Why separate \'stable findings\' from \'disputed findings\' in reports?',
        options: [
          'Aesthetics',
          'Readers apply different trust levels to each; burying contested findings among stable ones misleads',
          'Regulatory',
          'Token savings '
        ],
        correctAnswerIndex: 1,
        explanation: '—  Structural separation supports correct trust calibration by readers. Conflating them misrepresents confidence.  Study Strategy & Tips I Focus on engineering judgment. The exam builds 4-option questions where 3 are plausible; correct answers point toward sound engineering decisions, not memorized facts. I Internalize these 5 mental models: (1) model-driven vs hard-coded control flow (stop_reason, not iteration caps); (2) programmatic enforcement (hooks) vs prompt guidance; (3) subagent context isolation — nothing inherits automatically; (4) tool description as primary selection mechanism; (5) lost-in-the-middle + provenance preservation. I Memorize exact terminology: stop_reason values (end_turn, tool_use, max_tokens, stop_sequence); CLAUDE.md hierarchy (user/project/directory paths); MCP scope (.mcp.json vs ~/.claude.json); tool_choice modes (auto/any/specific); CLI flags (-p, --output-format json, --json-schema). I Study all 6 scenarios, even though only 4 appear on any given exam. Scenarios overlap multiple domains. I Recommended free resources: Anthropic Academy (Skilljar) — Claude 101, AI Fluency, Building with the Claude API, Introduction to MCP, Claude Code training, Agent Skills. I Build 2-3 real projects before attempting the exam: RAG with Claude API, tool-using agent, multi-agent workflow. I Take the official practice test at anthropic.skilljar.com before booking the real exam. It mirrors the real question format with explanations. I Know the subdomains: This bank is organized by subdomain because the exam guide (and the real questions) are written per-subdomain. If you\'re weak on Subdomain 5.6 (provenance), the 4-5 questions in that subdomain target exactly what you need to practice. Sources Scraped I github.com/paullarionov/claude-certified-architect — primary open-source study guide with exam framework and examples I certsafari.com/anthropic/claude-certified-architect — 610 practice questions with full subdomain breakdown I claudecertifications.com — 25 curated practice questions + 12-week study plan I dev.to/aws-builders — 5 domains, 6 scenarios breakdown with honest exam perspective I tutorialsdojo.com/cca-f-claude-certified-architect-foundations-study-guide — domain notes I dynamicbalaji.medium.com — preparation guide from passing candidate I newsletter.bigtechcareers.com — 5-day study plan walkthrough I medium.com/data-science-collective — complete study guide with tutor prompts per domain I Official exam guide PDF (everpath-course-content.s3-accelerate.amazonaws.com) — skills measured per subdomain'
      ),
    ]
  )
];

# AI-Policy

> This policy is partly based on the [postmarketOS AI Policy](https://docs.postmarketos.org/policies-and-processes/development/ai-policy.html) licensed under the [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/).

> This policy is effective from the time it was contributed to this repository. It does not include previous commits.

This AI-Policy defines how code contributions via Large Language Models (LLM) are allowed in Self.Tube.

All contributions that include AI-generated content such as code, issues, pull requests, or documentation will be declined. This includes all Large Language Models such as, but not limited to, ChatGPT, Claude, Copilot, and Mistral.

###	 Reasoning

AI tools have several ethical issues. They require an unreasonable amount of
energy[^1] and water[^2] to build and operate, their models are built in part
with heavily exploited workers in unacceptable working conditions[^3], usually
without consent from or compensation for creators of the source material[^4]
and oftentimes causing DDoS attacks against FOSS infrastructure in the
process[^5] (which in turn force the deployment of challenge-based protections
and increase cost and complexity of self-hosting for everybody[^6]).
Furthermore they are being used to undermine labor and justify layoffs[^7].
These are harms that we do not want to perpetuate, even if only indirectly.

Additionally authors making use of generative AI tools oftentimes increase the
maintainer burden and cause further problems by not ensuring the following:

* Understanding completely how the code in their contribution works.
* Describing the change accurately in the commit message.
* Testing the contribution and ensuring it works as described.
* Making sure their patches are unlikely to introduce bugs, especially security
  bugs.
* Not violating copyright (such as software licenses, creative commons or any
  other).

[^1]:   *"After pledging to slash its greenhouse gas
        emissions, Microsoft’s climate pollution has grown by 30 percent as the
        company prioritizes AI."*
        &mdash; [The Verge](https://www.theverge.com/2024/5/15/24157496/microsoft-ai-carbon-footprint-greenhouse-gas-emissions-grow-climate-pledge), 2024-05-15

[^2]:   *"Over the past 12 years, 16 data centers have been approved in Santiago’s
        metropolitan area. Most use millions of liters of water annually to keep
        computers from overheating. Chile is in the midst of a drought, expected to
        last until 2040."*
        &mdash; [Rest of World](https://restofworld.org/2024/data-centers-environmental-issues/), 2024-05-31

[^3]:   *"OpenAI Used Kenyan Workers on Less Than $2 Per Hour to Make ChatGPT
        Less Toxic"*
        &mdash; [TIME](https://time.com/6247678/openai-chatgpt-kenya-workers/),
        2023-01-18

[^4]:   *"Amid the rise of generative AI, creators, artists and media rights
        holders have been forced to reckon with the unlicensed use of their
        copyrighted material to train AI models without consent or
        compensation."*
        &mdash; [Variety](https://variety.com/vip-special-reports/ai-training-consent-content-licensing-special-report-1236307878/), 2025-03-03

[^5]:   *"When one of these botnets goes nuts, the result is indistinguishable
        from a distributed denial-of-service (DDOS) attack — it is a distributed
        denial-of-service attack. Should anybody be in doubt about the moral
        integrity of the people running these systems, a look at the techniques
        they use should make the situation abundantly clear.*"
        &mdash; [LWN.net](https://lwn.net/Articles/1008897/), 2025-02-14

[^6]:   [Anubis](https://anubis.techaro.lol/) is being used by the postmarketOS gitlab instance and wiki as well as [many other
        sites](https://anubis.techaro.lol/docs/user/known-instances/) and Alpine's gitlab is protected by [go-away](https://git.gammaspectra.live/git/go-away) to fight off scrapers. 
        Many other websites have adopted similar restrictions.

[^7]:   *"Since the rise of generative AI, many have feared the toll it would
        take on the livelihood of human workers. Now CEOs are admitting AI’s
        impact and layoffs are starting to ramp up."*
        &mdash; [Forbes](https://www.forbes.com/sites/richardnieva/2025/07/17/ai-tech-layoffs/), 2025-07-17

post = Post.find_or_initialize_by(slug: "wrong-screen-ai-overconfidence")
post.assign_attributes(
  title: "I Bought the Wrong Screen for My 3D Printer, and an AI Was Very Confident It Didn't Matter",
  category: "3D Printing",
  published_at: post.published_at || Time.current,
  body: <<~MARKDOWN
    I wanted a cheap status display for my 3D printer, running [CYD-Klipper](https://github.com/suchmememanyskill/CYD-Klipper). It turns a $10 ESP32 "Cheap Yellow Display" board into a wireless status screen for Klipper. The project supports two hardware variants: a 2.8" resistive touchscreen and a 3.5" capacitive one. I went looking for one of those.

    A discount caught my eye instead. I clicked through to a similar-looking board, didn't notice it wasn't the same product, and ended up with a 3.5" *resistive* variant (ESP32-3248S035R) that CYD-Klipper had never heard of.

    ## AI: The World's Fastest Overconfident Junior Engineer

    I pointed Cursor at the repo and asked it to build support for the missing variant using the 2.8" resistive and 3.5" capacitive configs as templates. Within minutes it had generated a board definition, a device driver, PlatformIO config, CI integration, and documentation. It looked complete. It had never touched real hardware.

    I asked if I should push it and flash it. The agent's answer was an unambiguous yes — the config was "specifically designed for your hardware" and "thoroughly validated." At some point during testing this got pushed as a real PR against the upstream project's main branch, and the maintainer's response was fast and not gentle:

    > "Please don't make PRs for boards on the main branch; use the dev branch. Preferably write the code yourself, not using AI :( There are unneeded files in the PR now, and tests that don't do anything."

    And then: "does this even work?" It didn't. I closed the PR and told him it was opened by accident mid-testing.

    ## Everything that was actually wrong

    Turns out "does this even work" was a completely fair question. What followed was several real days of hardware debugging:

    - The first build didn't compile (wrong display driver assumed).
    - Fixed, it flashed. Then it boot looped with `invalid header` errors. For a few rounds of "clean rebuild, wipe everything and redownload on a second laptop, still broken," it looked like the fix somehow hadn't taken. Turned out I'd been re-pasting the old compile-error log by mistake instead of the actual runtime error, a dumb, human reason to lose an hour and a good reminder to double check what you're actually looking at before trusting a diagnosis.
    - Once we were looking at the real error: driver swaps, partition table changes, and a genuine (correctly ruled-out) suspicion about an idle SD card in the slot. The actual cause, several wrong turns in: the board wasn't the individual-driver architecture the agent had built for at all. It was a completely different firmware family, a "Smart Display" board, something I only figured out by digging through the original AliExpress listing and reading chip markings off the board itself (an `AROKON R3` touch chip, `XPT2406` printed on the digitizer).
    - Once on the right architecture, the display finally lit up with a calibration screen. Touch didn't respond. What followed was two more laptops' worth of systematically testing IRQ pins (36, 21, 18, 22, 4, none of them worked), a detour into swapping to a capacitive GT911 touch chip (wrong guess, more SPI conflicts, a corrupted-flash scare that wiped the calibration screen entirely), and finally going back to basics: matching the *exact* SPI configuration from the working 2.8" resistive board (`SPI3_HOST`, IRQ on pin 36, 2MHz clock, queue depth 3) instead of guessing at new ones. Along the way, the symptom itself became the signal: a stable calibration screen meant the display path was still intact, and a flashing white screen meant the latest change had introduced a new conflict, which was usually enough to tell a wrong guess from an actual regression.
    - With that config, plus `TOUCH_SWAP_XY=true`, touch worked.

    ## Cleaning up on purpose

    The maintainer's comment about AI slop stuck with me. Once the board actually worked, I went back through the branch and stripped out the artificially generated docs, the test file that didn't test anything, and anything that wasn't the actual fix. That meant matching how every other board in the project is contributed: just a config file and a README entry, no dedicated test suite, which I confirmed by checking the project's own conventions first.

    I prepared a clean PR with just that, but decided not to reopen it. I'm not a C developer, and after the first PR I didn't want to hand the maintainer another AI-assisted submission to referee in a language I don't really know. Instead I kept the fix in [my own fork](https://github.com/kskilt/CYD-Klipper-3.5Resistive), public on GitHub, crediting the original project, so anyone who wants it can find it and fork it directly rather than route back through him. It's been running on my printer daily since.

    ## What actually mattered here

    The technical fix wasn't the hard part in the end: matching a known-good SPI config and finding the right touch flag. The more useful part was everything around it. An AI tool that sounds equally confident whether it's right or completely wrong, a maintainer who called that out bluntly and fairly, and the actual debugging (reading chip markings, checking an AliExpress listing, testing pins one at a time across two laptops) that only a human willing to verify against real hardware was going to do. The AI was fast at generating the next guess. It was never the thing that confirmed any of them were true.
  MARKDOWN
)
post.save!
puts "Seeded post: #{post.slug}"

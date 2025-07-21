***blaze***
---
personal educational/research project to study microkernel development, porting methods and computer architecture.

***how to*** 
---
run on qemu-system-aarch64:
```sh
qemu-system-aarch64 -M virt -cpu cortex-a53 -nographic -kernel ./build/bin/blaze 
```

***roadmap*** to 0.1
---
The goal of release 0.1 is to have a working aarch64 microkernel that manages interrupts, threads, processes, memory at a basic level. 

> [!NOTE]
> there is a list of abstract top-level tasks, during work the abstract task is broken down into small specific tasks and progress is noted in this roadmap.

- [x] repository setup
  - [x] basic git setup
  - [x] build environment
  - [ ] \(Optional) ci/cd
- [x] arch startup
- [ ] memory
- [ ] clock
- [ ] timer
- [ ] thread and scheduling
- [ ] locks and waiting
- [ ] interrupts
- [ ] processes and context switching
- [ ] syscalls
- [ ] user elf loading
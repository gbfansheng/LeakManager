# LeakManager
iOS Leak Checker(泄露检查器，加强版）

演化：
MLeaksFinder -> PLeakSniffer -> LeakManager
MLeaksFinder对View、ViewController进行了检测
PLeakSniffer对property进行了检测
LeakManager改进到对方法内的对象进行检测（误报概率提升，有待优化）

检测时机依然是popViewController后进行检测，通过建立弱引用表NSHashTable对所有对象进行持有和检测


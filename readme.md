love使用笔记

https://github.com/a327ex/blog/issues/30


1. 调试的时候console不能输出, launch文件中的 love 换成 lovec 就可以了.

第二节:库的使用,讲解了这个游戏中需要使用到的一些库.
感觉一点点学有点太慢了,先整体看一遍吧.
整理看完了.
后面的内容基本就是一点点的实现整个游戏,不过看英文还是有点费劲.先学习一下下面的这个教程,感觉不错.

https://alexarjing.github.io/

前四节基本看完了，现在根据之前的思路，用最新的love11 复现第五节需要达到的效果。

https://github.com/love2d-community/awesome-love2d

这里可以找到一下各种love2d开发游戏需要用到的库

## 06

讲了如何实现一些玩家相关的特效

07 加了加速限制，弹药

08 敌人相关的

画敌人相关的对象，石头，发射物等等

09 Director And Game Loop

Director : 各种资源的分配器？
涉及到难度曲线设计，这部分可以认真看看相关的逻辑。

- 1. Every 22 seconds difficulty will go up;
- 2. In the duration of each difficulty enemies will be spawned based on a point system
- - Each difficulty (or round) has a certain amount of points available to be used;
- - Enemies cost a fixed amount of points (harder enemies cost more);
- - Higher difficulties have a higher amount of points available;
- - Enemies are chosen to be spawned along the round's duration randomly until it runs out of points.
- 3. Every 16 seconds a resource (HP, SP or Boost) will be spawned;
- 4. Every 30 seconds an attack will be spawned.


- 难度和分数的对应关系？这个是什么作用？
- chance_list 保障25%发生的事情一定是100次发生25次。不放回抽样？
- director通过控制每个敌人的生成来控制难度（敌人会自然消亡，所以不必去在意敌人的清除）

07/08/09 一起看，这三个可以

10 关于代码的最佳实践

有讨论对于团队和个人而言，特别是个人而且，怎么做虽然不是传统意义上的最佳实践，但实际操作上反而会更好一些。

比如： 

### 全局变量的问题

全局变量其实非常不错，且高效率。并且游戏不太需要长期维护。
给出了可以用全部变量的地方
1. the first type are global variables that are read from a lot and rarely written to. 
频繁读，但是基本不写入的变量。（全局变量的问题就是多个地方同时写会产生非预期行为）
2. The second type are global variables that are written to a lot and rarely read from. ？
单纯只是写。
3. 频繁读写的，的确不适合全局变量。

### Abstracting vs. Copypasting

抽象 vs 复制粘贴的问题

### Player Class Size
类大小问题

### Entity Component Systems
ECS开发模式









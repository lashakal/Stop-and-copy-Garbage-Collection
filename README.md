# Stop-and-copy-Garbage-Collection

The project simulates a stop-and-copy garbage collection algorithm in Racket. It consists of two semi-spaces, "from-space" and "to-space," which represent different memory regions. Memory allocation is done in the "from-space," and when it runs out of space, garbage collection is triggered.

The key components of the project include:
1. Semi-Spaces: The memory is divided into two semi-spaces of equal size. These semi-spaces are initially filled with default cells containing (0, 0).
2. Memory Allocation: The alloc-cell function is used to allocate new cells in the from-space. When the from-space is full, it triggers garbage collection.
3. Garbage Collection: The collect-garbage function is responsible for identifying and copying live cells from the from-space to the to-space based on a provided root set. Cells that are no longer reachable are deallocated.
4. Live Cell Detection: The is-live? function checks if a cell is live based on a given root set. Cells that are in the root set or reachable from it are considered live.
5. Copying Cells: The copy-cell function copies a cell from the from-space to the to-space and updates the scan pointer.
6. Swap Semi-Spaces: After garbage collection, the roles of the from-space and to-space are swapped to prepare for the next allocation cycle.
7. Example Function: An example function (example) demonstrates the garbage collection process. It allocates cells, removes references, performs garbage collection, and displays the contents of cells before and after garbage collection.

In summary, this project provides a practical implementation of a stop-and-copy garbage collection algorithm, helping manage memory efficiently by identifying and reclaiming unreachable memory cells.






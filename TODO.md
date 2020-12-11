# To-Do List

1. **Efficiency issues**
	* register forwarding is stalling for rv1 and rv2 regardless of whether instruction needs them or not. That is, even if rv2 is not needed (say, for load), the rs2 may accidentally match rd in some stage and stall till its value is acquired. Instruction dependency checks will be needed to prevent this, but as of now, it causes unintended stalling, which while functionally fine, is not good efficiency-wise

2. **Generation issues**
	* Perform generation of both variants simultaneously

3. **Testing issues**
	* Add testing

4. **Further developments**
	* Add functionality for RISC-V extensions
	* Look into RocketChip and incorporate some features here

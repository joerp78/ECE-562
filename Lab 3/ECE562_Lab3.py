INPUT_WIDTH = 8
ACCUM_WIDTH = 32

# Slice registers (current and next values)
x_reg_current = [0, 0, 0]
x_reg_next = [0, 0, 0]
y_reg_current = [0, 0, 0]
y_reg_next = [0, 0, 0]

# Weights
W = [0, 0, 0]

#Simulate one clock cycle with proper timing
def clock_tick(X_in, Yprev):
    global x_reg_current, x_reg_next, y_reg_current, y_reg_next
        
    # Slice 0
    x0_in = X_in
    mult0 = W[0] * x_reg_current[0]
    add0 = mult0 + Yprev
    x_reg_next[0] = x0_in
    y_reg_next[0] = add0
    
    # Slice 1  
    x1_in = x_reg_current[0]  # X from slice 0 output
    mult1 = W[1] * x_reg_current[1]
    add1 = mult1 + y_reg_current[0]  # Y from slice 0 output
    x_reg_next[1] = x1_in
    y_reg_next[1] = add1
    
    # Slice 2
    x2_in = x_reg_current[1]  # X from slice 1 output
    mult2 = W[2] * x_reg_current[2]
    add2 = mult2 + y_reg_current[1]  # Y from slice 1 output
    x_reg_next[2] = x2_in
    y_reg_next[2] = add2
    
    #Clock edge: Update registers
    x_reg_current = x_reg_next[:]
    y_reg_current = y_reg_next[:]

def display_state(label, X_in, Yprev):
    """Display current state (shows values BEFORE clock edge)"""
    print(f"{label:10s} | W=[{W[0]:2d},{W[1]:2d},{W[2]:2d}] X_in={X_in:3d} Yprev={Yprev:4d} | "
          f"Y0={y_reg_current[0]:6d} Y1={y_reg_current[1]:6d} Y2={y_reg_current[2]:6d}")

def reset():
    """Reset all registers"""
    global x_reg_current, x_reg_next, y_reg_current, y_reg_next
    x_reg_current = [0, 0, 0]
    x_reg_next = [0, 0, 0]
    y_reg_current = [0, 0, 0]
    y_reg_next = [0, 0, 0]

# TEST CASES
print("Systolic Array Python Simulation")
print(f"INPUT_WIDTH={INPUT_WIDTH}, ACCUM_WIDTH={ACCUM_WIDTH}")

# TEST CASE 1
print("\nEST CASE 1: Yprev = 0\n")

reset()
W[0] = 2
W[1] = 3
W[2] = 4
Yprev = 0
X_in = 0

display_state("INIT", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 1
display_state("X=1", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 2
display_state("X=2", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 3
display_state("X=3", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 4
display_state("X=4", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 0
for _ in range(5):
    display_state("PROP", X_in, Yprev)
    clock_tick(X_in, Yprev)

# TEST CASE 2
print("\nTEST CASE 2: Non-zero Yprev\n")

Yprev = 100

display_state("INIT", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 5
display_state("X=5", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 10
display_state("X=10", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 0
for _ in range(5):
    display_state("PROP", X_in, Yprev)
    clock_tick(X_in, Yprev)

# TEST CASE 3
print("\nTEST CASE 3: Interleaved Streams\n")

Yprev = 0

display_state("INIT", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 1
display_state("S1:1", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 10
display_state("S2:10", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 2
display_state("S1:2", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 20
display_state("S2:20", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 3
display_state("S1:3", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 30
display_state("S2:30", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 0
for _ in range(6):
    display_state("PROP", X_in, Yprev)
    clock_tick(X_in, Yprev)

print("\nTEST CASE 4: Negative Arithmetic Validation\n")

W[0] = -2
W[1] = 3
W[2] = -1
Yprev = -10
X_in = 0

display_state("INIT", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = -5
display_state("X=-5", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 4
display_state("X=4", X_in, Yprev)
clock_tick(X_in, Yprev)

X_in = 0
for _ in range(5):
    display_state("PROP", X_in, Yprev)
    clock_tick(X_in, Yprev)

print("All test cases completed")
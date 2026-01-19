echo "Generando problemas..."

####    2 x 2   ####
# Nivel Fácil
python3 problem_generator.py 2 5 "./problems/problem_2x2_1.pddl"
python3 problem_generator.py 2 5 "./problems/problem_2x2_2.pddl"
python3 problem_generator.py 2 5 "./problems/problem_2x2_3.pddl"
# Nivel Medio
python3 problem_generator.py 2 15 "./problems/problem_2x2_4.pddl"
python3 problem_generator.py 2 15 "./problems/problem_2x2_5.pddl"
python3 problem_generator.py 2 15 "./problems/problem_2x2_6.pddl"
# Nivel Difícil
python3 problem_generator.py 2 30 "./problems/problem_2x2_7.pddl"
python3 problem_generator.py 2 30 "./problems/problem_2x2_8.pddl"
python3 problem_generator.py 2 30 "./problems/problem_2x2_9.pddl"

####    3 x 3   ####
# Nivel Fácil
python3 problem_generator.py 3 5 "./problems/problem_3x3_1.pddl"
python3 problem_generator.py 3 5 "./problems/problem_3x3_2.pddl"
python3 problem_generator.py 3 5 "./problems/problem_3x3_3.pddl"
# Nivel Medio
python3 problem_generator.py 3 15 "./problems/problem_3x3_4.pddl"
python3 problem_generator.py 3 15 "./problems/problem_3x3_5.pddl"
python3 problem_generator.py 3 15 "./problems/problem_3x3_6.pddl"
# Nivel Difícil
python3 problem_generator.py 3 30 "./problems/problem_3x3_7.pddl"
python3 problem_generator.py 3 30 "./problems/problem_3x3_8.pddl"
python3 problem_generator.py 3 30 "./problems/problem_3x3_9.pddl"

####    4x4     ####
# Nivel Fácil
python3 problem_generator.py 4 5 "./problems/problem_4x4_1.pddl"
python3 problem_generator.py 4 5 "./problems/problem_4x4_2.pddl"
python3 problem_generator.py 4 5 "./problems/problem_4x4_3.pddl"
# Nivel Medio
python3 problem_generator.py 4 15 "./problems/problem_4x4_4.pddl"
python3 problem_generator.py 4 15 "./problems/problem_4x4_5.pddl"
python3 problem_generator.py 4 15 "./problems/problem_4x4_6.pddl"
# Nivel Difícil
python3 problem_generator.py 4 30 "./problems/problem_4x4_7.pddl"
python3 problem_generator.py 4 30 "./problems/problem_4x4_8.pddl"
python3 problem_generator.py 4 30 "./problems/problem_4x4_9.pddl"

echo "Problemas generados"
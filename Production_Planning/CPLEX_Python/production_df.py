# --------------------------------------------------------------------------
# Source file provided under Apache License, Version 2.0, January 2004,
# http://www.apache.org/licenses/
# (c) Copyright IBM Corp. 2015, 2018
# --------------------------------------------------------------------------

"""The model aims at minimizing the production cost for a number of products
while satisfying customer demand. Each product can be produced either inside
the company or outside, at a higher cost.

The inside production is constrained by the company's resources, while outside
production is considered unlimited.

The model first declares the products and the resources.
The data consists of the description of the products (the demand, the inside
and outside costs, and the resource consumption) and the capacity of the
various resources.

The variables for this problem are the inside and outside production for each
product.
"""

from docplex.mp.model import Model
from docplex.util.environment import get_environment
import pandas
import pdb
# ----------------------------------------------------------------------------
# Initialize the problem data
# ----------------------------------------------------------------------------
PRODUCTS = [("kluski", 100, 0.6, 0.8),
            ("capellini", 200, 0.8, 0.9),
            ("fettucine", 300, 0.3, 0.4)]
product_df = pandas.DataFrame(data = PRODUCTS, columns = ['producto', 'demanda', 'costo_interno','costo_externo'])
# resources are a list of simple tuples (name, capacity)
RESOURCES = [("flour", 20),
             ("eggs", 40)]
resource_df = pandas.DataFrame(data = RESOURCES, columns = ['recurso','cantidad'])
CONSUMPTIONS = {("kluski", "flour"): 0.5,
                ("kluski", "eggs"): 0.2,
                ("capellini", "flour"): 0.4,
                ("capellini", "eggs"): 0.4,
                ("fettucine", "flour"): 0.3,
                ("fettucine", "eggs"): 0.6}
consumption_rows = [(key[0],key[1],CONSUMPTIONS[key]) for key in CONSUMPTIONS.keys()]
consumption_df = pandas.DataFrame(data = consumption_rows, columns = ['producto','recurso','consumo'])

# ----------------------------------------------------------------------------
# Build the model
# ----------------------------------------------------------------------------
def build_production_problem(product_df, resource_df, conumption_df, **kwargs):
    """ Takes as input:
        - a list of product tuples (name, demand, inside, outside)
        - a list of resource tuples (name, capacity)
        - a list of consumption tuples (product_name, resource_named, consumed)
    """
    mdl = Model(name='production', log_output = False, **kwargs)
    # --- decision variables ---
    product_df['inside'] = mdl.continuous_var_list(
                               [row.producto for row in product_df.itertuples()],
                               lb = [0]*len(product_df),
                               name = 'inside'
                           )
    product_df['outside'] = mdl.continuous_var_list(
                                [row.producto for row in product_df.itertuples()],
                                lb = [0]*len(product_df),
                                name = 'outside'
                            )
    # --- constraints ---
    # demand satisfaction
    #mdl.add_constraints((mdl.inside_vars[prod] + mdl.outside_vars[prod] >= prod[1], 'ct_demand_%s' % prod[0]) for prod in products)
    mdl.add_constraints((row.inside + row.outside >= row.demanda, 'ct_demand_{}'.format(row.producto)) for row in product_df.itertuples())

    # --- resource capacity ---
    #mdl.add_constraints((mdl.sum(mdl.inside_vars[p] * consumptions[p[0], res[0]] for p in products) <= res[1],
    #                     'ct_res_%s' % res[0]) for res in resources)
    merge_df = product_df.merge(consumption_df, on = 'producto')
    merge_df = merge_df.merge(resource_df, on = 'recurso')
    merge_df['consumo_expr'] = merge_df.inside * merge_df.consumo
    gb = merge_df.groupby(by = 'recurso').agg({'consumo_expr': mdl.sum, 'cantidad': min}).reset_index()
    mdl.add_constraints((row.consumo_expr <= row.cantidad, 'ct_res_{}'.format(row.recurso)) for row in gb.itertuples())
    # --- objective ---
    mdl.total_inside_cost = mdl.sum(row.inside * row.costo_interno for row in product_df.itertuples())
    mdl.add_kpi(mdl.total_inside_cost, "inside cost")
    mdl.total_outside_cost = mdl.sum(row.outside * row.costo_externo for row in product_df.itertuples())
    mdl.add_kpi(mdl.total_outside_cost, "outside cost")
    mdl.minimize(mdl.total_inside_cost + mdl.total_outside_cost)
    return mdl


def print_production_solution(mdl, product_df):
    obj = mdl.objective_value
    print("* Production model solved with objective: {:g}".format(obj))
    print("* Total inside cost=%g" % mdl.total_inside_cost.solution_value)
    for row in product_df.itertuples():
        print("Inside production of {product}: {ins_var}".format
              (product=row.producto, ins_var=row.inside.solution_value))
    print("* Total outside cost=%g" % mdl.total_outside_cost.solution_value)
    for row in product_df.itertuples():
        print("Outside production of {product}: {out_var}".format
              (product=row.producto, out_var=row.outside.solution_value))


def build_default_production_problem(**kwargs):
    return build_production_problem(PRODUCTS, RESOURCES, CONSUMPTIONS, **kwargs)

# ----------------------------------------------------------------------------
# Solve the model and display the result
# ----------------------------------------------------------------------------
if __name__ == '__main__':
    # Build the model
    model = build_production_problem(product_df, resource_df, consumption_df)
    model.print_information()
    # Solve the model.
    if model.solve():
        print_production_solution(model, product_df)
        # Save the CPLEX solution as "solution.json" program output
        with get_environment().get_output_stream("solution.json") as fp:
            model.solution.export(fp, "json")
    else:
        print("Problem has no solution")
from experta import Fact, KnowledgeEngine, Rule, DefFacts, MATCH

class SoilTest(Fact):
    pass

class FertilizerRecommendation(KnowledgeEngine):
    @DefFacts()
    def initial_facts(self):
        yield SoilTest(crop="Paddy A", soil_n=15, soil_p=25, soil_k=20, diseases=["Disease Y"])

    @Rule(SoilTest(crop="Paddy A", soil_n=MATCH.n, soil_p=MATCH.p, soil_k=MATCH.k, diseases=MATCH.d))
    def recommend_fertilizer(self, n, p, k, d):
        if n < 20:
            print("Apply Urea")
        if p < 10:
            print("Apply DAP")
        if k < 15:
            print("Apply MOP")

engine = FertilizerRecommendation()
engine.reset()
engine.run()
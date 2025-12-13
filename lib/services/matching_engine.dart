import '../models/actor_profile_model.dart';
import '../models/casting_call_model.dart';

class MatchingEngine {
  // Demo AI Matching Algorithm
  static double calculateMatchScore(ActorProfile actor, CastingCall castingCall) {
    double score = 0.0;

    // Age matching (40%)
    if (actor.age >= castingCall.ageMin && actor.age <= castingCall.ageMax) {
      score += 40;
    } else {
      int ageDifference = (actor.age - castingCall.ageMin).abs();
      score += (40 - (ageDifference * 2)).clamp(0.0, 40.0);
    }

    // Gender matching (20%)
    if (castingCall.requiredGender == 'Any' || castingCall.requiredGender == actor.gender) {
      score += 20;
    }

    // Skills matching (25%)
    int skillMatches = 0;
    for (String skill in castingCall.requiredSkills) {
      if (actor.skills.contains(skill)) {
        skillMatches++;
      }
    }
    if (castingCall.requiredSkills.isNotEmpty) {
      double skillPercentage = (skillMatches / castingCall.requiredSkills.length) * 25;
      score += skillPercentage;
    } else {
      score += 25;
    }

    // Language matching (15%)
    int languageMatches = 0;
    for (String language in castingCall.requiredLanguages) {
      if (actor.languages.contains(language)) {
        languageMatches++;
      }
    }
    if (castingCall.requiredLanguages.isNotEmpty) {
      double languagePercentage = (languageMatches / castingCall.requiredLanguages.length) * 15;
      score += languagePercentage;
    } else {
      score += 15;
    }

    return score.clamp(0.0, 100.0);
  }

  static Future<List<ActorProfile>> findMatchesForCasting(
    CastingCall castingCall,
    List<ActorProfile> allActors,
  ) async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 2));

    List<MapEntry<ActorProfile, double>> scoredActors = [];

    for (ActorProfile actor in allActors) {
      double score = calculateMatchScore(actor, castingCall);
      if (score >= 50) {
        // Only include if score is 50 or above
        scoredActors.add(MapEntry(actor, score));
      }
    }

    // Sort by score descending
    scoredActors.sort((a, b) => b.value.compareTo(a.value));

    return scoredActors.map((entry) => entry.key).toList();
  }
}

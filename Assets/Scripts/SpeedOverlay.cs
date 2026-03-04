using System.Linq;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class SpeedOverlay : MonoBehaviour
{
    public PlayerBoost gameState;
    public Material overlay;
    public Color speedColor;
    public Color baseColor;
    public Color slowColor;
    
    // penser à mettre ça au click de changement de gear
    // avec un event system globalisé
    void Update()
    {
        switch (gameState.boostState)
        {
            case BoostStates.Gear1:
                overlay.color = slowColor;
                break;
            case BoostStates.Gear2:
                overlay.color = baseColor;
                break;
            case BoostStates.Gear3:
                overlay.color = speedColor;
                break;
        }
    }
}

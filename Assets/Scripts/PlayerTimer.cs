using TMPro;
using UnityEngine;
using TMPro;

public class PlayerTimer : MonoBehaviour
{
    public float timer;
    public float t;
    public TextMeshProUGUI text;
    private PlayerBoost playerBoost;
    
    void Start()
    {
        playerBoost = GetComponent<PlayerBoost>();
        t = timer;
    }
    
    void Update()
    {
        t -= Time.deltaTime * playerBoost.timerMult;
        text.text = t.ToString("0.00");
        
        if (t <= 0f)
        {
            Debug.Log("OUTTA TIME !!!");
        }
    }
}

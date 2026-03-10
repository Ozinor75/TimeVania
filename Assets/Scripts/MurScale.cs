using UnityEngine;

public class MurScale : MonoBehaviour
{
    [Header("Paramètres de la marée")]
    public float acceleratedTime = 2f;
    public float normalTime = 1f;
    public float slowedTime = 0.5f;    

    [Header("Objet Flottant (Le Holder)")]
    public Transform holder;
    public float scaleMinimumX = 1f;
    public float scaleMaximumX = 5f;

    public bool inverserSens = false;
    private Vector3 positionInitiale;
    private Vector3 scaleInitial;
    private Vector3 offsetHolder; 
    
    public GlobalTime globalTime;
    private float timeScale;
    private float tempsAccumule = 0f;
    
    void Start()
    {
        positionInitiale = transform.localPosition;
        scaleInitial = transform.localScale;
        globalTime = FindAnyObjectByType<GlobalTime>();
        timeScale = normalTime;
        
        if (holder != null)
        {
            float direction = inverserSens ? -1f : 1f;
            Vector3 sommetInitial = transform.position + (transform.right * direction * (transform.lossyScale.x / 2f));
            offsetHolder = holder.position - sommetInitial;
        }
    }

    void Update()
    {
        if (globalTime != null)
        {
            switch (globalTime.worldTime)
            {
                case WorldTime.ONE: timeScale = acceleratedTime; break;
                case WorldTime.TWO: timeScale = normalTime; break;
                case WorldTime.THREE: timeScale = slowedTime; break;
            }
        }

        tempsAccumule += Time.deltaTime * timeScale;
        float vague = (Mathf.Sin(tempsAccumule) + 1f) / 2f;
        float nouveauScalex = Mathf.Lerp(scaleMinimumX, scaleMaximumX, vague);
        
        Vector3 nouveauScale = scaleInitial;
        nouveauScale.x = nouveauScalex;
        transform.localScale = nouveauScale;
        
        float direction = inverserSens ? -1f : 1f;
        Vector3 nouvellePosition = positionInitiale;
        float differenceDeTaille = nouveauScalex - scaleInitial.x;
        
        nouvellePosition.x = positionInitiale.x + (direction * differenceDeTaille / 2f);
        transform.localPosition = nouvellePosition;
        if (holder != null)
        {
            Vector3 sommetActuel = transform.position + (transform.right * direction * (transform.lossyScale.x / 2f));
            holder.position = sommetActuel + offsetHolder;
        }
    }
}